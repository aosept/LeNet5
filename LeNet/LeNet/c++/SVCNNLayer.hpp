//
//  SVCNNLayer.hpp
//  MLPractice
//
//  Created by 威 沈 on 08/08/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#ifndef SVCNNLayer_hpp
#define SVCNNLayer_hpp

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <stdlib.h>

//#define debugLayerIndex 10
//#define debugDError_dout 1
//#define debugDout_dnet 0
//#define debugDnet_dw 0
//#define debugDeltaRule 0
//#define debugDwv 0

enum NetType
{
    NetTypeConvolutions = 0,
    NetTypeSubsampling,
    NetTypeFullconnection,
    NetTypeOutPut,
    
};
enum ActiveStyle
{
    ActiveStyleSigmoid = 0,
    ActiveStyleRelu,
    ActiveStyleRelu6,
    ActiveStyleRelu1,
    ActiveStyleTanh,
    
};

class SVCNNLayer
{
public:
    NetType type;
    ActiveStyle activeStyle;
    int debugLayerIndex;
    int debugDError_dout;
    int debugDout_dnet;
    int debugDnet_dw;
    int debugDeltaRule;
    int debugDwv;
    int countOfCase;
    int rowOfIn;        //28*28*1
    int colOfIn;        //28
    int layerCountOfIn;      //1 or 6 or 10 or 120
    int colOfOut;       //24
    int rowOfOut;       //24
    int featureMapCount;   //6
    int featureSize;  // 5
    int sliceStep;
    int index;          //training index
    float ***input;
    float ****w;         //5*5 or 4*4
    float ***net;       //24*24*6
    float ***out;       //24*24*6
    
    float *dETotal_dOut;
    float *dhout_dnet;
    float ****dnet_dw;
    
    float ****dw;//[cH0][cH1]
    float ****finalDw;
    float *delta;

    float b;
    SVCNNLayer()
    {
        
    }
    SVCNNLayer(int _rowOfIn,int _colOfIn,int _layerCountOfIn,int _featureMapCount,int _featureSize,int _colOfOut,int _rowOfOut,int _sliceStep,NetType _type);
    ~SVCNNLayer();
    void  logSetting(int _debugLayerIndex,
                     int _debugDError_dout,
                     int _debugDout_dnet,
                     int _debugDnet_dw,
                     int _debugDeltaRule,
                     int _debugDwv)
    {
        debugLayerIndex = _debugLayerIndex;
        debugDError_dout = _debugDError_dout;
        debugDout_dnet = _debugDout_dnet;
        debugDnet_dw = _debugDnet_dw;
        debugDeltaRule = _debugDeltaRule;
        debugDwv = _debugDwv;
    }
    
    void  resetlogSetting()
    {
        debugLayerIndex = -1;
        debugDError_dout = 0;
        debugDout_dnet = 0;
        debugDnet_dw = 0;
        debugDeltaRule = 0;
        debugDwv = 0;
    }
    float sigmoid(float x);
    float tanh(float x);
    float dtanh(float x);
    float activate(float x);
    float dactivate(float x);
    float relu6(float x);
    float relu(float x);
    float relu1(float x);
    float dRelu1(float x);
    float uniform(float min, float max);
    void cleanNetOut()
    {
        for (int m = 0; m < featureMapCount; m++)
        {
            for(int i = 0; i < rowOfOut; i ++)
            {
                for (int j = 0; j < colOfOut; j ++) {
                    
                    net[m][i][j] = 0;
                    out[m][i][j] = 0;
                }
            }
        }
        
    }
   void ProductWith(float*** inData)
    {

        cleanNetOut();
        
        if(type == NetTypeConvolutions)
        {
            convolutionFilter(inData);
        }
        else  if(type == NetTypeSubsampling)
        {
            subsamplingFiter(inData);
        }
        else if(type == NetTypeFullconnection)
        {
            fullConnnectionFiter(inData);
        }
        else
        {
            printf("undefined");
        }
        
        
    }
    float dRelu(float out)
    {
        
       
            
            if(out == 0)
            {
                return 0;
            }
            else
            {
                return 1;
            }
            
        
    }
    float dsigmoid(float out)
    {
         return  out*(1.0 - out);
    }
    float dRelu6(float out)
    {
        
        
        
        if(out == 0 || out == 6)
        {
            return 0;
        }
        else
        {
            return 1.0;
        }
        
        
    }
    void fullConnnectionFiter(float*** inData)
    {

        input = inData;
        
        for (int m = 0; m < featureMapCount; m++)
        {
            float r = 0;
            for(int i = 0; i < layerCountOfIn; i ++)
            {
                    r += inData[i][0][0]*w[m][i][0][0];
            }
            r = r/layerCountOfIn;
            r = r + b;
            net[m][0][0] = r;
            r = activate(r);
            out[m][0][0] = r;
        }

    }
    void subsamplingFiter(float*** inData)
    {
        input = inData;
//        int *inputLayerIndex;
        int inputLayerCount = 0;
        //        int sliceStep =  (rowOfIn - featureSize )/(rowOfOut -1);
        for (int m = 0; m < featureMapCount; m++)
        {
//            inputLayerIndex = m;//getInputLayerIndex(m); // new
            
            inputLayerCount = 1;//getInputLayerCount(m);
            
            for (int n = 0; n < inputLayerCount; n++) { // === 1 loop only
                
                int layerIndex = m;
                
                for(int i = 0; i < rowOfOut; i ++)
                {
                    for (int j = 0; j < colOfOut; j ++) {
                        
                        float r = 0;
                        r = maxValue(inData[layerIndex], i*sliceStep, j*sliceStep);
                        
                        net[m][i][j] = r;
                        
                    }
                }
                
                
            }
            
            for(int i = 0; i < rowOfOut; i ++)
            {
                for (int j = 0; j < colOfOut; j ++) {
                    float r = 0;
                    r = net[m][i][j];
                    r = activate(r);
                    out[m][i][j] = r;
                }
            }
            
//            delete [] inputLayerIndex;
        }
    }
    float maxValue(float** inData,int frowRow,int fromCol)
    {
       
        float r = 0;
        float mV = 0;
        for (int i =0; i < featureSize; i++) {
            for (int j =0; j < featureSize; j++) {
                float t = inData[frowRow+i][fromCol+i];
                mV = fmax(mV, t);
            }
        }
        r = mV;
        return r;
    }
    void convolutionFilter(float*** inData)
    {
        input = inData;
        int *inputLayerIndex;
        int inputLayerCount = 0;
        //        int sliceStep =  (rowOfIn - featureSize )/(rowOfOut -1);
        for (int m = 0; m < featureMapCount; m++)
        {
            inputLayerIndex = getInputLayerIndex(m); // new
            
            inputLayerCount = getInputLayerCount(m);
            
            for (int n = 0; n < inputLayerCount; n++) {
                
                int layerIndex = inputLayerIndex[n];
                
                for(int i = 0; i < rowOfOut; i ++)
                {
                    for (int j = 0; j < colOfOut; j ++) {
                        
                        float r = 0;
                        r = featureByW(inData[layerIndex],m,n, i*sliceStep, j*sliceStep);
                        
                        net[m][i][j] += r;
                        
                    }
                }
                
                
            }
            
            for(int i = 0; i < rowOfOut; i += sliceStep)
            {
                for (int j = 0; j < colOfOut; j += sliceStep) {
                    float r = 0;
                    r = net[m][i][j];
                    if(index == 4)
                    {
                        r = r/120.0;
                    }
                    r = activate(r);
                    out[m][i][j] = r;
                }
            }
            
            if(index == 6 )//debug
            {
                for (int i=0 ; i < rowOfOut; i++) {
                    printf("\n");
                    for(int j =0; j < colOfOut; j++)
                    {
                        printf(" %.17f\t",out[m][i][j]);
                    }
                }
//                printf("");
            }
            
            delete [] inputLayerIndex;
        }
    }
   float featureByW(float** inData,int featureIndex,int inputLayerIndex,int frowRow,int fromCol)
    {
        float r = 0;
        for (int i =0; i < featureSize; i++) {
            for (int j =0; j < featureSize; j++) {
//                if(inData[frowRow+i][fromCol+i] > 0)
//                    printf("%.10f",inData[frowRow+i][fromCol+i]);
                float id = inData[frowRow+i][fromCol+i];
                float wv = w[featureIndex][inputLayerIndex][i][j];
                float rd = id*wv;
                if(isnan(rd))
                {
//                    printf("index:%d",index);
//                    printf("");
                    rd = 1;
                }
                r +=inData[frowRow+i][fromCol+i]*w[featureIndex][inputLayerIndex][i][j];
            }
        }
        r = r + b;
        return r;
    }
    void dnetdWvalue(int featureIndex,int inputLayerIndex, float** inData,int frowRow,int fromCol)
    {
        float r = 0;
        float size = (colOfIn-featureSize+1);
        size = size*size;
        if(size == 0)
            size = 1;
        
            for (int i =0; i < featureSize; i++) {
                for (int j =0; j < featureSize; j++) {
                    r += inData[frowRow+i][fromCol+j];
                    dnet_dw[featureIndex][inputLayerIndex][i][j] = r/size;
                    
                }
            }
    }
    int* getInputLayerIndex(int cuurentFeatureIndex)
    {
        int countOfLayer = getInputLayerCount(cuurentFeatureIndex);
        int* layerIndex = new int[countOfLayer];
        if(index != 2)
        {
            for (int i =0; i< countOfLayer; i++) {
                layerIndex[i] = i;
            }
            
        }
        else
        {
            int layerMartix[16][6] =
            {
                {0,1,2,0,0,0},
                {1,2,3,0,0,0},
                {2,3,4,0,0,0},
                {3,4,5,0,0,0},
                {0,4,5,0,0,0},
                {0,1,5,0,0,0},
                {0,1,2,3,0,0},
                {1,2,3,4,0,0},
                {2,3,4,5,0,0},
                {3,4,5,0,0,0},
                {4,5,0,1,0,0},
                {5,0,1,2,0,0},
                {0,1,3,4,0,0},
                {1,2,0,0,4,5},
                {0,2,3,5,0,0},
                {0,1,2,3,4,5},
            };
            
            
            for (int i =0; i< countOfLayer; i++) {
                layerIndex[i] = layerMartix[cuurentFeatureIndex][i];
            }
        }
        return layerIndex;
    }
    int getFeatureLayerCount(int cuurentFeatureIndex)
    {
        if (index == 2)
        {
            return 10;
        }
        else
        {
            if(type == NetTypeSubsampling)
            {
                return 1;
            }
            else
            {
                return featureMapCount;
            }
        }
    }
    int* getFeatureLayerIndex(int currentInputIndex)
    {
        int countOfLayer = getFeatureLayerCount(currentInputIndex);
        int* layerIndex = new int[countOfLayer];
        if(index != 2)
        {
            for (int i =0; i< countOfLayer; i++) {
                layerIndex[i] = i;
            }
            
        }
        else
        {
            int layerMartix[6][16] =
            {
                {0,4,5,6,9,10,11,12,14,15,0,0,0,0,0,0},//10
                {0,1,5,6,7,10,11,12,13,15,0,0,0,0,0,0}, //10
                {0,1,2,6,7,8,11,13,14,15,0,0,0,0,0,0}, //10
                {1,2,3,6,7,8,9,12,14,15,0,0,0,0,0,0}, //10
                {2,3,4,7,8,9,10,12,13,15,0,0,0,0,0,0},//10
                {3,4,5,8,9,10,11,13,14,15,0,0,0,0,0,0},//10
            
            };
            
            
            for (int i =0; i< countOfLayer; i++) {
                layerIndex[i] = layerMartix[currentInputIndex][i];
            }
        }
        return layerIndex;
    }
   int getInputLayerCount(int cuurentFeatureIndex)
    {
        if (index == 2)
        {
            if(cuurentFeatureIndex >=0 && cuurentFeatureIndex < 6)
                return 3;
            else if(cuurentFeatureIndex < 15)
                return 4;
            else
            {
                return 6;
            }
        }
        else
        {
            if(type == NetTypeSubsampling)
            {
                return 1;
            }
            else
            {
                return layerCountOfIn;
            }
        }
    }
    
    void cleanDw()
    {
        for(int k =0; k < featureMapCount; k++)
        {
            for (int m =0; m < layerCountOfIn; m++) {
                for (int j = 0; j<featureSize ; j++) {
                    for (int i = 0; i < featureSize; i++) {
                        finalDw[k][m][j][i] =0;
                        dw[k][m][j][i] =0;
                        dnet_dw[k][m][i][j] = 0;
                    }
                }
            }
            
        }
    }
    int maxPosition()
    {
        int v = 0;
        double max = 0;
        int mi =0,mj=0,mk=0;
//        printf("\n");
        for (int i =0; i<featureMapCount; i++) {
            for (int j =0; j<rowOfOut; j++) {
                for (int k=0; k < colOfOut; k++) {
                    double o = out[i][j][k];
                    if(max < o)
                    {
                        max = o;
                        mi = i;
                        mj = j;
                        mk = k;
                    }
//                    printf("%.4f(%.4f)\t",o,net[i][j][k]);
                }
            }
        }
//        printf("\n");
        v = mi*rowOfOut*colOfOut + mj*rowOfOut + mk;
        return v;
    }
    void dErrordout(float *targetdata)
    {
        
        for (int i = 0; i < featureMapCount; i++) {
            dETotal_dOut[i]= -1*(targetdata[i] - out[i][0][0]);
        }
        
        if(index == debugLayerIndex && debugDError_dout)
        {
            printf("\n\n%s\n\n",__func__);
            printf("dETotal_dOut:\n");
            for (int i =0; i<featureMapCount; i++) {
                for (int j =0; j<rowOfOut; j++) {
                    for (int k=0; k < colOfOut; k++) {
                        printf("%d %d %d %.10f\n",i,j,k,dETotal_dOut[ i*rowOfOut*colOfOut + j*rowOfOut + k]);
                    }
                }
            }
//            printf("");
        }
        
       
    }
    
    float deltaError(float *targetdata)
    {
        float d =0;
        for (int i = 0; i < featureMapCount; i++) {
            d += dETotal_dOut[i]*dETotal_dOut[i];
        }
        return d;
    }
    
    void dnetdwConvolutions()
    {
        int *inputLayerIndex;
        int inputLayerCount = 0;
       
        for (int k =0; k < featureMapCount; k++)
        {
            for (int n = 0; n< layerCountOfIn; n++) {
                for (int i = 0; i<featureSize; i++) {
                    
                    for (int j =0; j<featureSize; j++) {
                        dnet_dw[k][n][i][j] = 0;
                    }
                }
            }
        }
        
        
        
        for (int m = 0; m < featureMapCount; m++)
        {

            inputLayerCount = getInputLayerCount(m);
            
            for (int n = 0; n < inputLayerCount; n++) {
                
                for(int i =0; i< featureSize; i++)
                {
                    for(int j =0; j< featureSize; j++)
                    {
                        dnet_dw[m][n][i][j] = 0;
                    }
                }
                float size = (rowOfIn-featureSize+1)*(colOfIn-featureSize+1);
                for(int i =0; i< featureSize; i++)
                {
                    for(int j =0; j< featureSize; j++)
                    {
                        float r = 0;
                        for(int k = 0; k < rowOfIn-featureSize+1; k += sliceStep)
                        {
                            for (int s = 0; s < colOfIn-featureSize+1; s += sliceStep) {
                                float v = input[n][k+i][s+j];
                                v = v/size;
                                r += v;
                            }
                        }
                        if(isnan(r))
                        {
                            r = 1;
                        }
                        dnet_dw[m][n][i][j] = r;
                    }
                }
            }
        }
        
        
        if(index == debugLayerIndex && debugDnet_dw)
        {
            printf("\n\n%s\n\n",__func__);
            for (int k =0; k < featureMapCount; k++)
            {
                for (int n = 0; n< layerCountOfIn; n++) {
                    for (int i = 0; i<featureSize; i++) {
                        
                        for (int j =0; j<featureSize; j++) {
                            
                            printf("dnet_dw[%d][%d][%d][%d] = %.17f\n",k,n,i,j,dnet_dw[k][n][i][j]);
                        }
                    }
                }
            }
        }
        
    }
    void dnetdwSubsampling()
    {
        for (int k =0; k<featureMapCount; k++) {
            for (int m =0; m < layerCountOfIn; m++) {
                float max = 0;
                int x = 0;
                int y = 0;
                for (int i = 0; i<featureSize; i++) {
                    for (int j =0; j<featureSize; j++) {
                        if(max < input[m][i][j])
                        {
                            max = input[m][i][j];
                            x = i;
                            y = j;
                        }
                        else
                        {
                            dnet_dw[k][m][i][j] = 0;
                            if(index == debugLayerIndex  && debugDnet_dw)
                                printf("%d %d %d %d %17f\n",k,m,x,y,dnet_dw[k][m][x][y]);
                        }
                    }
                }
                dnet_dw[k][m][x][y] = 1;
                if(index == debugLayerIndex  && debugDnet_dw)
                    printf("%d %d %d %d %17f\n",k,m,x,y,dnet_dw[k][m][x][y]);
            }
        }

    }
    void dnetdwFullConnection()
    {
//        printf("\ndnetdwFullConnection\n");
        for (int k = 0; k < featureMapCount; k++)
        {
            for (int n = 0; n < layerCountOfIn; n++) {
                
                for (int m =0; m < rowOfIn; m++) {
                    for(int i = 0; i < colOfIn; i ++)
                    {
                        dnet_dw[k][n][m][i] = input[n][m][i];
                        if(index == debugLayerIndex  && debugDnet_dw)
                            printf("%d %d %d %d %17f\n",k,n,m,i,dnet_dw[k][n][m][i]);
                    }
                }
            }
        }
    }
    void logDW()
    {
//        printf("\nindex:%d\n",index);
//        for (int k =0; k< featureMapCount; k++) {
//
//            for (int j = 0; j<featureSize ; j++) {
//                for (int i = 0; i < featureSize; i++) {
//                    printf("%.16f\t", dw[k][i][j]);
//                }
//                printf("\n");
//            }
//        }
    }
    void logfW()
    {
//        if(type == NetTypeFullconnection)
//        {
//            printf("\nindex:%d\n",index);
//            for (int i = 0; i<featureMapCount; i++) {
//                for (int j =0; j<layerCountOfIn; j++) {
//                    printf("%.16f\t", finalDw[0][i][j]);
//                }
//                printf("\n");
//            }
//        }
//        else
//        {
//            printf("\nindex:%d\n",index);
//            for (int k = 0; k<featureMapCount; k++) {
//                for (int j = 0; j<featureSize ; j++) {
//                    for (int i = 0; i < featureSize; i++) {
//                        printf("%.16f\t", finalDw[k][i][j]);
//                    }
//                    printf("\n");
//                }
//            }
//        }
    }
    void logW()
    {
//        if(type == NetTypeFullconnection)
//        {
//            printf("\nindex:%d\n",index);
//            for (int i = 0; i<featureMapCount; i++) {
//                for (int j =0; j<layerCountOfIn; j++) {
//                    printf("%.16f\t", w[0][i][j]);
//                }
//                printf("\n");
//            }
//        }
//        else
//        {
//            printf("\nindex:%d\n",index);
//            for (int k = 0; k<featureMapCount; k++) {
//                for (int j = 0; j<featureSize ; j++) {
//                    for (int i = 0; i < featureSize; i++) {
//                        printf("%.16f\t", w[k][i][j]);
//                    }
//                    printf("\n");
//                }
//            }
//        }
    }
    void saveDw()
    {
        int countOflayer = getInputLayerCount(index);
        int *layerIndex = getInputLayerIndex(index);
        if (index == debugLayerIndex) {
//            printf("");
            
        }
        
        
        for (int m = 0; m < featureMapCount; m++) {
            for (int p = 0; p < countOflayer; p++){
//                int layerIndexNumber = layerIndex[p];
                
                for (int i = 0; i<featureSize; i++) {
                    for (int j =0; j<featureSize; j++) {
                        float  dwv = dw[m][p][j][i];
                        if(countOfCase == 0)
                        {
                            countOfCase = 1;
                            printf("%s%d Error",__func__,__LINE__);
                        }
                        dwv = dwv/countOfCase;
                        float oldFinalDw = finalDw[m][p][j][i];
                        if(isnan(dwv))
                        {
                            printf("");
                        }
                        
                        if(isnan(oldFinalDw))
                        {
                            printf("");
                        }
                        oldFinalDw =  dwv + oldFinalDw;
                        
                        if(isnan(oldFinalDw))
                        {
                            printf("");
                        }
                        finalDw[m][p][j][i] = oldFinalDw;
                        
                        if(index == debugLayerIndex)
                        {
                            if(dw[m][p][i][j] < 0 || dw[m][p][i][j] > 0)
                                printf("index:%d finalDw[%d][%d][%d][%d]:%17f,dw[k][m][i][j]:%17f\n",index,m,p,i,j,finalDw[m][p][j][i],dw[m][p][i][j]);
                        }
                    }
                }
            }
        }
        
        
        delete [] layerIndex;
        

    }
    
    void updateWbyFinalDW(float step)
    {
        int countOflayer = getInputLayerCount(index);
//        int *layerIndex = getInputLayerIndex(index);
        
        for (int k = 0; k<featureMapCount; k++) {
            for(int m = 0; m < countOflayer; m++){
                for (int j = 0; j<featureSize ; j++) {
                    for (int i = 0; i < featureSize; i++) {
                        float dv  = 0;
                        dv = finalDw[k][m][j][i];
                        if(isnan(dv))
                        {
                            printf("");
                            dv = 1;
                        }
                        if(countOfCase == 0)
                            countOfCase = 1;
//                        dv = dv/countOfCase;
                        dv = dv*step;
                        w[k][m][j][i] = w[k][m][j][i] - dv;
                        
                        if(index == debugLayerIndex)
                        {
                            if(dv > 0 || dv < 0)
                            {
                                printf("old:%17f  [%d][%d][%d][%d][%d]: [%.17f]\n",w[k][m][j][i],index,k,m,j,k,dv);
                            }
                        }
                        
                        finalDw[k][m][j][i] = 0;
                        dw[k][m][j][i] = 0;
                    }
                }
            }
        }

    }
    
    void dwv()
    {
        int countOflayer = getInputLayerCount(index);
        int *layerIndex = getInputLayerIndex(index);
        if (index == debugLayerIndex) {
            printf("");
            printf("\n\n%s\n\n",__func__);
        }
        
        for (int m = 0; m < featureMapCount; m++) {
            for (int p = 0; p < countOflayer; p++){
                int outContyByThisLayer = getFeatureLayerCount(p);
                int *outContyByThisLayerIndex = getFeatureLayerIndex(p);
                for (int q = 0; q < outContyByThisLayer; q++)
                {
                    int indexOfOutLayer = outContyByThisLayerIndex[q];
                    
                    for (int i = 0; i<featureSize; i++) {
                        for (int j =0; j<featureSize; j++) {
                            dw[m][p][j][i] = 0;
                            float tdelta = 0;
                            for(int n = 0; n < rowOfOut; n+=sliceStep){
                                for(int k = 0; k < colOfOut; k+=sliceStep)
                                {
                                    double tmpDelta = delta[m*rowOfOut*colOfOut + n*rowOfOut +k];
                                    if(isnan(tmpDelta))
                                    {
                                        printf("%s%d Error",__func__,__LINE__);
                                    }
                                    tmpDelta = tmpDelta/outContyByThisLayer;
                                    tdelta += tmpDelta;
                                    if(index == debugLayerIndex  && debugDwv)
                                    {
                                        printf("");
//                                        printf("%d [%d][%d][%d][%d] delta:%17f\n",index,m,p,i,j,delta[indexOfOutLayer*rowOfOut*colOfOut + n*rowOfOut +k]);
                                    }
                                }
                            }
//                            tdelta = tdelta/outContyByThisLayer;
                            
                            if(isnan(tdelta))
                            {
                                printf("%s%d Error",__func__,__LINE__);
                            }
                            tdelta = tdelta *dnet_dw[m][p][j][i];
                            
                            if(isnan(tdelta))
                            {
                                printf("%s%d Error",__func__,__LINE__);
                            }
                            if(index == debugLayerIndex && debugDwv)
                            {
                                if(tdelta != 0)
                                {
                                    
                                    printf("%d [%d][%d][%d][%d] delta:%17f\n",index,m,p,i,j,tdelta);
                                }
                            }
                            
                            if(isnan(tdelta))
                            {
                                 printf("%s%d Error",__func__,__LINE__);
                            }
                            
                            dw[m][p][j][i] = tdelta;///(featureMapCount*rowOfOut*colOfOut)
                            
                        }
                    }
                }
                delete [] outContyByThisLayerIndex;
                
            }
        }
        
        
        delete [] layerIndex;

    }
    void dnetdw()
    {
        if(index == debugLayerIndex && debugDnet_dw)
        {
            printf("");
        }
//
        if(type == NetTypeFullconnection)
        {
            dnetdwFullConnection();
        }
        else if(type == NetTypeSubsampling)
        {
            dnetdwSubsampling();
        }
        else if(type == NetTypeConvolutions)
        {
            
            dnetdwConvolutions();
            
        }
        else
        {
            printf("\nerror\n");
        }

        if(index == debugLayerIndex && debugDnet_dw)
        {
            printf("\n\n%s\n\n",__func__);
            printf("\ndNet dw of Conv:\n");
            for (int k =0; k < featureMapCount; k++)
            {
                for (int m = 0; m< layerCountOfIn; m++)
                {
                    for (int i = 0; i<featureSize; i++) {
                        
                        for (int j =0; j<featureSize; j++) {
                            printf("[%d]dnet_dw %d %d %d %d %.17f\n",index,k,m,i,j,dnet_dw[k][m][i][j]);
                        }
                    }
                }
                
            }
//            printf("");
        }
        

        
        
    }
    void deltaRule()
    {
        
        for (int m = 0; m < featureMapCount; m++)
        {
            for(int i = 0; i < rowOfOut; i ++)
            {
                for (int j = 0; j < colOfOut; j ++) {
                    int p = m*rowOfOut*colOfOut + i*rowOfOut + j;//position
                    float eo = dETotal_dOut[p];
                    if(isnan(eo))
                    {
//                        printf("%s%d Error",__func__,__LINE__);
                        eo = 0;
                    }
                    float on = dhout_dnet[p];
                    if(isnan(on))
                    {
//                        printf("%s%d Error",__func__,__LINE__);
                        on = 0;
                    }
                    float rd = eo*on;
                    
                    if(isnan(rd))
                    {
//                        printf("%s%d Error",__func__,__LINE__);
                        rd = 0;
                    }
                    delta[p] = rd;
                    if(isnan(delta[p]) || delta[p] > 20)
                    {
                        if(index == debugLayerIndex && debugDeltaRule)
                        {
                            printf("");
                            
                        }
                    }
                }
            }
            
        }
        
        if(index == debugLayerIndex && debugDeltaRule)
        {
            printf("\n\n%s\n\n",__func__);
            printf("delta Value:%d\n",index);
            for (int i =0; i<featureMapCount; i++) {
                for (int j =0; j<rowOfOut; j++) {
                    for (int k=0; k < colOfOut; k++) {
                        printf("line:%d(%d): %d %d %d %.10f\n",__LINE__,index,i,j,k,delta[ i*rowOfOut*colOfOut + j*rowOfOut + k]);
                    }
                }
            }
//            printf("");
        }
        
        
        
    }
    void doutdnet()
    {
        for (int m = 0; m < featureMapCount; m++)
        {
            for(int i = 0; i < rowOfOut; i ++)
            {
                for (int j = 0; j < colOfOut; j ++) {
                    
                    if(type == NetTypeFullconnection)
                    {
                        dhout_dnet[m*rowOfOut*colOfOut + i*rowOfOut + j] = dactivate(out[m][i][j]);//out[m][i][j]*(1- out[m][i][j]);
                    }
                    else
                    {
                        dhout_dnet[m*rowOfOut*colOfOut + i*rowOfOut + j] = dactivate(out[m][i][j]);
                    }
                    
                    if(index == debugLayerIndex && debugDout_dnet)
                    {
                      
                        printf("%d,%d,%d,dhout_dnet[m*rowOfOut*colOfOut + i*rowOfOut + j]: %17f\n",m,i,j,dhout_dnet[m*rowOfOut*colOfOut + i*rowOfOut + j]);
                    }
                }
            }
//            printf(" ");
        }
    }
    
   
    float deltaMultiplyByWeightOfConvolution(int featureIndex,int inputLayerIndex,int inputRowIndex,int inputColIndex,SVCNNLayer* nextLayer)
    {
        float dr = 0;
        
        int * inputLayers = getFeatureLayerIndex(inputLayerIndex); // new
        int layerCount = getFeatureLayerCount(inputLayerIndex);

        for (int n = 0; n < layerCount; n++) { // === 1 loop only

            int index = inputLayers[n];

            int startRow = inputRowIndex-featureSize+1;

            if(startRow < 0)
                startRow = 0;

            int endRow =  inputRowIndex+featureSize-1;

            if(endRow >  rowOfOut)
            {
                endRow =  rowOfOut;
            }


            int startCol = inputColIndex-featureSize+1;

            if(startCol < 0)
                startCol = 0;

            int endCol =  inputRowIndex+featureSize-1;

            if(endCol >  rowOfOut)
            {
                endCol =  rowOfOut;
            }

            int nextContentSize = nextLayer->colOfOut*nextLayer->rowOfOut;

            for(int i = startRow; i< endRow ; i++)
            {
                for (int j= startCol; j < endRow; j++) {
                    for (int k =0; k < nextLayer->featureSize; k++) {
                        for (int l =0; l < nextLayer->featureSize; l++) {

                            dr += nextLayer->delta[index*(nextContentSize) + i*(nextLayer->rowOfOut) +j]*nextLayer->w[featureIndex][index][k][l];
                        }
                    }
                }
            }
        }
        delete [] inputLayers;
        return dr;
    }
    void dErrordout(SVCNNLayer* nextlayer)
    {
        if(index == debugLayerIndex && debugDError_dout)
        {
//            printf("");
        }
        
        
        if(nextlayer->type == NetTypeFullconnection)  // same with upper code
        {

            for (int i =0; i< featureMapCount; i++) {
                dETotal_dOut[i] = 0;
                for(int j = 0; j< nextlayer->featureMapCount; j++)
                {
                    float del = nextlayer->delta[j];
                    if(isnan(del))
                    {
                        printf("%s%d Error",__func__,__LINE__);
                    }
                    float nw = nextlayer->w[j][i][0][0];
                    if(isnan(nw))
                    {
                        printf("%s%d Error",__func__,__LINE__);
                    }
                    float  rded =  del*nw;
                    if(isnan(rded))
                    {
                        printf("%s%d Error",__func__,__LINE__);
                    }
                    float oldrded = dETotal_dOut[i];
                    if(isnan(oldrded))
                    {
                        printf("%s%d Error",__func__,__LINE__);
                    }
                    double deo = oldrded + rded;
                    if(isnan(deo))
                    {
                        printf("%s%d Error",__func__,__LINE__);
                    }
                    dETotal_dOut[i] = deo;//i * 1*1
                    
                    if(dETotal_dOut[i] > 1000 || isnan(oldrded))
                    {
                        if(index == debugLayerIndex && debugDError_dout)
                        {
//                                    printf("");
                            oldrded = 1;
                        }
                    }
                }
            }
        }
        else if(nextlayer->type == NetTypeSubsampling )
        {
//            printf("");
            
            

            for (int m = 0; m < featureMapCount; m++)
            {
                
                for(int i = 0; i+nextlayer->featureSize < rowOfOut; i += nextlayer->sliceStep)
                {
                    for (int j = 0; j+nextlayer->featureSize < colOfOut; j += nextlayer->sliceStep) {
                        float max = 0;
                        int mRow =0;
                        int mCol = 0;
                        
                       
                        
                        for (int k = 0; k < nextlayer->featureSize; k++) {
                            for (int n = 0; n < nextlayer->featureSize; n++) {
                                if(max < out[m][i+k][j+n])
                                {
                                    max = out[m][i+k][j+n];
                                    mRow = i+k;
                                    mCol = j+n;
                                }
                                else
                                {
                                    dETotal_dOut[(m*rowOfOut*colOfOut + (i+k)*rowOfOut + j+n)] = 0;
                                }
                            }
                        }
                        int  rowOfNextOut = nextlayer->rowOfOut;
                        int  colOfNextOut = nextlayer->colOfOut;
                        int layersize = rowOfNextOut * colOfNextOut;
                        int nextRow =i/nextlayer->sliceStep;
                        int nextCol = j/nextlayer->sliceStep;
                        
                        dETotal_dOut[((m*rowOfOut*colOfOut + (mRow)*rowOfOut + mCol))] = nextlayer->delta[m*layersize + nextRow*rowOfNextOut + nextCol];
                        if(index == debugLayerIndex  && debugDError_dout)
                        {
                            printf("nextlayer->delta[%d] :%.7f\n",m*layersize + nextRow*rowOfNextOut + nextCol,nextlayer->delta[m*layersize + nextRow*rowOfNextOut + nextCol]);
                        }
                    }
                }


            }
            
        }
        else if(nextlayer->type == NetTypeConvolutions)
        {
//            printf("");

            
            for (int m = 0; m < featureMapCount; m++)
            {
                for (int n =0; n < layerCountOfIn ; n++) {
                    for(int i = 0; i < rowOfOut; i ++)
                    {
                        for (int j = 0; j < colOfOut; j ++) {
                            dETotal_dOut[(m*rowOfOut*colOfOut + i*rowOfOut + j)] = deltaMultiplyByWeightOfConvolution(m,n,i, j,nextlayer);
                        }
                    }
                }
            }
            
            
            
//
            
//            printf("");
            
        }
        
        if(index == debugLayerIndex && debugDError_dout)
        {
            printf("\n\n%s\n\n",__func__);
            for (int i =0; i<featureMapCount; i++) {
                for (int j =0; j<rowOfOut; j++) {
                    for (int k=0; k < colOfOut; k++) {
                        printf("%d %d %d %.10f\n",i,j,k,dETotal_dOut[ i*rowOfOut*colOfOut + j*rowOfOut + k]);
                    }
                }
            }
//            printf("");
        }
    }
};

#endif /* SVCNNLayer_hpp */
