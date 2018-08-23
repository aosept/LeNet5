//
//  SVCNNNetWork.hpp
//  MLPractice
//
//  Created by 威 沈 on 08/08/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#ifndef SVCNNNetWork_hpp
#define SVCNNNetWork_hpp

#include <stdio.h>
#include <iostream>
#include <mutex>
#include <atomic>
#include <sstream>
#include <thread>
#include <stdlib.h>
#include "SVCNNLayer.hpp"


class SVCNNNetWork
{
//    std::thread training_thread;
public:
    SVCNNLayer **layers;
    int countOfLayer;
    int inputNumber;
    int outNumber;
    int countOfcase;
    float*** trainingdata;
    float *targetdata;
    
    
    float*** trainingdataList;
    float** targetdataList;
    float step;
    bool isDebug;
    
    int trainloopCount;
    float sheldhold;
    bool isTraining;
    float sliceStep;
    void (*loginfo)(const void* callback,const char* logstring);
    void (*didRecieveDataCallback)(const void* callback,const char* key, const float** value, float delta);
    void (*trainDataProvider)(const void*callback,const int dataIndex);
    void *callbackNSObject;
    
    SVCNNNetWork()
    {

        inputNumber = 28*28;
        outNumber = 10;
        isDebug = false;
        layers = new SVCNNLayer*[7];
     
        countOfLayer = 7;
        layers[0] = new SVCNNLayer(32,32,1,6,5,28,28,1,NetTypeConvolutions);// rowofIn + slicestep = rowOfout*slicestep + featuresize
        layers[0]->index = 0;
        layers[0]->activeStyle = ActiveStyleRelu6;
        layers[0]->countOfCase = countOfcase;
        
        layers[1] = new SVCNNLayer(28,28,6,6,2,14,14,2,NetTypeSubsampling);// 24 + 2 = 12 * 2 + 2
        layers[1]->index = 1;
        layers[1]->activeStyle = ActiveStyleRelu6;
        layers[1]->countOfCase = countOfcase;
        
        layers[2] = new SVCNNLayer(14,14,6,16,5,10,10,1,NetTypeConvolutions);// sliceStep = (rowOfIn - featureSize )/(rowOfOut -1);
        layers[2]->index = 2;
        layers[2]->activeStyle = ActiveStyleRelu6;
        layers[2]->countOfCase = countOfcase;
        
        layers[3] = new SVCNNLayer(10,10,16,16,2,5,5,2,NetTypeSubsampling);
        layers[3]->index = 3;
        layers[3]->activeStyle = ActiveStyleRelu6;
        layers[3]->countOfCase = countOfcase;
        
        layers[4] = new SVCNNLayer(5,5,16,120,4,1,1,1,NetTypeConvolutions);
        layers[4]->index = 4;
        layers[4]->activeStyle = ActiveStyleRelu6;
        layers[4]->countOfCase = countOfcase;
        
        layers[5] = new SVCNNLayer(1,1,120,84,1,1,1,1,NetTypeFullconnection);
        layers[5]->index = 5;
        layers[5]->activeStyle = ActiveStyleRelu6;
        layers[5]->countOfCase = countOfcase;
        
        layers[6] = new SVCNNLayer(1,1,84,10,1,1,1,1,NetTypeFullconnection);
        layers[6]->index = 6;
        layers[6]->activeStyle = ActiveStyleRelu6;
        layers[6]->countOfCase = countOfcase;
        
        trainingdataList = NULL;
        targetdataList = NULL;
    };
    void setCountOfcase(int count)
    {
        countOfcase = count;
        for (int i =0; i < countOfLayer; i++) {
            SVCNNLayer* layer = layers[i];
            layer->countOfCase = count;
        }
    }
    void setLayerLog(int index,int derrordout,int doutdnet,int dnetdw,int ddelta,int dwv)
    {
        for (int i =0; i < countOfLayer; i++) {
            SVCNNLayer* layer = layers[i];
            if(i == layer->index)
            {
                layer->logSetting(index, derrordout, doutdnet, dnetdw, ddelta, dwv);
            }
            else
            {
                layer->logSetting(index, 0, 0, 0, 0, 0);
            }
        }
    }
    void logArray(float* list,int count)
    {
        
        for(int i = 0;i < count ;i++)
        {
            
            printf("%.17f\t",list[i]);
            
        }
        printf("\n");
    }
    void logMartrix(float** martrix,int m,int n)
    {
        for(int i = 0;i < m ;i++)
        {
            for (int j = 0; j<n; j++) {
                printf("%.17f\t",martrix[i][j]);
            }
            printf("\n");
        }
    }
//    void dataListClear()
//    {
//        if(trainingdataList != NULL)
//        {
//            
//            for (int i = 0; i < 28; i++) {
//                delete [] trainingdataList[0][i];
//            }
//            delete [] trainingdataList[0];
//            delete [] trainingdataList;
//            
//            trainingdataList = NULL;
//        }
//        
//        
//        if(targetdataList != NULL)
//        {
//            delete [] targetdataList[0];
//            delete [] targetdataList;
//            
//            trainingdataList = NULL;
//            targetdataList = NULL;
//        }
//    }
    void dataListSet(float ***_trainingData,float **_targetData)
    {
        
        trainingdataList = _trainingData;
        targetdataList = _targetData;
        
        
    }
    void dataset(float ***_trainingData,float* _targetData)
    {
        
        trainingdata = _trainingData;
        targetdata = _targetData;
        
    }

    ~SVCNNNetWork()
    {
//        if(training_thread.joinable())
//            training_thread.join();
        if(layers != NULL)
        {
            for(int i=0; i<countOfLayer; i++)
                delete layers[i];
            
            delete [] layers;
        }
        
    };
    void trainWithCount(int count,float sheldholdValue)
    {
        
        //         if( training_thread.joinable())
        //             training_thread.join();
        //
        trainloopCount = count;
        sheldhold = sheldholdValue;
        //          training_thread = std::thread([this]() {
        
        
        int loop = 0;
        float delta =  1;
        while (loop < trainloopCount && delta > sheldhold)
        {
            run();
            delta = training();
//            printf("%d delta:\t%.10f\n",loop,delta);
            
            loop++;
            
        }
        printf("finished");
        
        //        });
        
        
        
    }
    void showResult()//test
    {
        for(int c = 0; c < countOfcase; c++)
        {
           
            
//            dataset(input, target);
//            run();
            
            
            printf("\n");

        }
        for (int i = 0; i< countOfLayer ; i++) {

        }
        
    }
    float trainWithMultiData()
    {
        float subDelta = 0;
        int inputImageW = 32;
        int imputImageH = 32;
        for(int c = 0; c < countOfcase; c++)
        {
            if (trainDataProvider != NULL) {
                trainDataProvider(callbackNSObject,c);
            }
            
            float ***input =   new float**[1];//
            input[0] = new float*[imputImageH];//hard code
            
            for (int i  = 0; i<imputImageH; i++) {
                input[0][i] = new float[inputImageW];
                for(int j = 0;j<inputImageW  ;j++)
                {
                   input[0][i][j] = trainingdataList[0][i][j];//  trainingdataList have one data only
                    
                }
                
            }
            
            float *target = targetdataList[0];// targetdataList[c];
            
            printf("Target value:\t");
            for(int i = 0;i<10;i++)
            {
                if( target[i] < 1 )
                    printf("%d(%f)\t",i,target[i]);
            }
//            printf("over \n");
            dataset(input, target);
            run();
            printf("predictValue:%d\n",predictValue());
            subDelta += training();
            
            
            for (int i  = 0; i<imputImageH; i++) {
                delete [] input[0][i];
            }
            delete [] input[0];
            delete [] input;
        }
        
        return subDelta;
    }
    void trainWithMultiDataCount(int count,float sheldholdValue,float hrate)
    {
        
        trainloopCount = count;
        sheldhold = sheldholdValue;

        step = hrate;
        
        int loop = 0;
        float delta =  1;
        while (loop < trainloopCount && delta > sheldhold)
        {
            if(loop > 100)
            {
//                step = step*1.0001;
            }
            else
            {
               
            }
            
            if(step > 50)
            {
                step = 50;
            }
            delta = trainWithMultiData();
            
            updateMultiCaseDw();
            clearMultiCaseDw();
            
            
            if (didRecieveDataCallback != NULL && loop%1 ==0) {
                
                
                for (int m=0; m< countOfLayer; m++) {
                    
                    if(m == 6)
                    {
                        SVCNNLayer* layer =  layers[m];
                        for(int i = 0;i< layer->featureMapCount;i++)
                        {
                            const float **v = (const float **)layer->out[i];
                            char keyName[64];

                            sprintf(keyName, "%d_%d %.10f [%.2f]", m,i,v[0][0],targetdata);
//                            printf("%s\n", keyName);
                            float size = layer->rowOfOut;
                            didRecieveDataCallback(callbackNSObject,keyName,v,size);
                        }
                    }
                }
            }
            
            
            int dstep = count/300.0 + 1;

            if(loop%dstep ==0)
            {
                printf("%d delta:\t%.10f\n",loop,delta);
                
                if (didRecieveDataCallback != NULL) {
                    didRecieveDataCallback(callbackNSObject,"resultOf",NULL,delta);
                }
            }
            
            loop++;
            
        }
        
        printf("finished");
        
        
        
    }
    void run()
    {
        for (int m=0; m< countOfLayer; m++) {
            if (m == countOfLayer -1) {
//                printf("%d",m);
            }
            
            if(m == 0)
            {
                SVCNNLayer* layer =  layers[m];
                layer->ProductWith(trainingdata);//,layer->rowOfIn,layer->colOfIn
            }
            else
            {
                if(m == 3)
                {
//                    printf("");
                }
                SVCNNLayer* prelayer =  layers[m-1];
                SVCNNLayer* layer =  layers[m];
                layer->ProductWith(prelayer->out);//,prelayer->rowOfOut,prelayer->colOfOut
            }
            
            if(m < 7)
            {
                SVCNNLayer* layer =  layers[m];
                for(int i = 0;i< layer->featureMapCount;i++)
                {
                    const float **v = (const float **)layer->out[i];
                    char keyName[64];
                    
                    sprintf(keyName, "%d_%d_%d_%d", m,i,layer->rowOfOut,layer->colOfOut);
                    //                            printf("%s\n", keyName);
                    float size = layer->featureSize;
                    didRecieveDataCallback(callbackNSObject,keyName,v,size);
                }
            }
            

        }
        
        
        
    };
    int predictValue()
    {
        SVCNNLayer* layer;
        
//        layer =  layers[5];
//        layer->maxPosition();
        layer =  layers[6];
        int v =0;
        v = layer->maxPosition();
        return v;
    }
    float training()
    {
        float d = 0;
        
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVCNNLayer* layer =  layers[m];
            if (m == 4) {
                printf("");
            }
            
            if(m == countOfLayer-1)
            {
                layer->dErrordout(targetdata);
                d += layer->deltaError(targetdata);
            }
            else
            {
                SVCNNLayer* nextlayer =  layers[m+1];
                layer->dErrordout(nextlayer);
            }
            
            
            layer->doutdnet();
            layer->deltaRule();
            layer->dnetdw();
            layer->dwv();
            layer->saveDw();
            
        }
        
        return sqrt(d);
    };
    void updateMultiCaseDw()
    {
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVCNNLayer* layer =  layers[m];
            layer->updateWbyFinalDW(step);
        }
    }
    void clearMultiCaseDw()
    {
        for (int m=countOfLayer-1; m >= 0 ; m--) {
            
            SVCNNLayer* layer =  layers[m];
            layer->cleanDw();
            
        }
    }

    
};

#endif /* SVCNNNetWork_hpp */
