//
//  SVCNNLayer.cpp
//  MLPractice
//
//  Created by 威 沈 on 08/08/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#include "SVCNNLayer.hpp"


float SVCNNLayer::uniform(float min, float max) {
    
    return rand() / (RAND_MAX + 1.0) * (max - min) + min;
}

SVCNNLayer::SVCNNLayer(int _rowOfIn,int _colOfIn,int _layerCountOfIn,int _featureMapCount,int _featureSize,int _colOfOut,int _rowOfOut,int _sliceStep,NetType _type)
{
    rowOfIn = _rowOfIn;
    colOfIn = _colOfIn;
    layerCountOfIn = _layerCountOfIn;
    featureSize = _featureSize;
    featureMapCount = _featureMapCount;
    colOfOut = _colOfOut;
    rowOfOut = _rowOfOut;
    sliceStep = _sliceStep;
    type = _type;
  

    resetlogSetting();
    w = new float***[featureMapCount];
    dnet_dw = new float***[featureMapCount];
    dw = new float***[featureMapCount];
    finalDw = new float***[featureMapCount];
    b = new float*[featureMapCount];
    db = new float*[featureMapCount];
    finaldb= new float*[featureMapCount];
        for (int k = 0; k < featureMapCount; k++) {
            
            w[k] = new float**[layerCountOfIn];
            dnet_dw[k] = new float**[layerCountOfIn];
            dw[k] = new float**[layerCountOfIn];
            finalDw[k] = new float**[layerCountOfIn];
            b[k] = new float[layerCountOfIn];
            db[k] = new float[layerCountOfIn];
            finaldb[k] = new float[layerCountOfIn];
            for (int m = 0; m < layerCountOfIn; m++) {
                
                w[k][m] = new float*[featureSize];
                dnet_dw[k][m] = new float*[featureSize];
                dw[k][m] = new float*[featureSize];
                finalDw[k][m] = new float*[featureSize];
                b[k][m] = uniform(-1.0, 1.0);
                db[k][m] = 0;
                finaldb[k][m] = 0;
                for (int i = 0; i < featureSize; i++) {
                    
                    w[k][m][i] = new float[featureSize];
                    dnet_dw[k][m][i] = new float[featureSize];
                    dw[k][m][i] = new float[featureSize];
                    finalDw[k][m][i] = new float[featureSize];
                    
                    for (int j=0; j < featureSize; j++) {
                        w[k][m][i][j] = uniform(-1.0, 1.0);
                        dnet_dw[k][m][i][j] = 0;
                        dw[k][m][i][j] = 0;
                        finalDw[k][m][i][j] =0;
                    }
                }
            }
        }
        
   
    
    
    
    
    net = new float**[featureMapCount];
    for (int i = 0; i < featureMapCount; i++) {
        net[i] = new float*[rowOfOut];
        for (int j=0; j < rowOfOut; j++) {
            net[i][j]= new float[colOfOut];
            for (int k = 0; k< colOfOut; k++) {
                net[i][j][k] = 0;
            }
        }
    }
    
    out = new float**[featureMapCount];
    for (int i = 0; i < featureMapCount; i++) {
        out[i] = new float*[rowOfOut];
        for (int j=0; j < rowOfOut; j++) {
            out[i][j]= new float[colOfOut];
            for (int k = 0; k< colOfOut; k++) {
                out[i][j][k] = 0;
            }
        }
    }
    
    /*
     float *dETotal_dOut;
     float *dhout_dnet;
     float **dnet_dw;
     
     float **dw;//[cH0][cH1]
     float **finalDw;
     float *delta;
     */
    
    int out_Count;
    
    out_Count = featureMapCount*colOfOut*rowOfOut;
    
    dETotal_dOut = new float[out_Count];
    dhout_dnet = new float[out_Count];
    delta = new float[out_Count];

    
    
    
    
    cleanDw();
    
    
}
SVCNNLayer::~SVCNNLayer()
{
    
    for (int i = 0; i < featureMapCount; i++) {
        
        for (int j=0; j < rowOfOut; j++) {
           delete [] net[i][j];
        }
        delete [] net[i];
    }
    delete [] net;
    
    for (int i = 0; i < featureMapCount; i++) {
        
        for (int j=0; j < rowOfOut; j++) {
            delete [] out[i][j];
        }
        delete [] out[i];
    }
    delete [] out;
    
    
    /*
     float *dETotal_dOut;
     float *dhout_dnet;
     float **dnet_dw;
     
     float **dw;//[cH0][cH1]
     float **finalDw;
     float *delta;
     */
    
    delete [] dETotal_dOut;
    delete [] dhout_dnet;
    delete [] delta;
    
    for (int k =0; k < featureMapCount; k++) {
        for (int m = 0; m < layerCountOfIn; m++) {
            for (int i =0; i< featureSize; i++) {
                
                delete [] dnet_dw[k][m][i];
                delete [] dw[k][m][i];
                delete [] finalDw[k][m][i];
                delete [] w[k][m][i];
            }
            
            delete [] dnet_dw[k][m];
            delete [] dw[k][m];
            delete [] finalDw[k][m];
            delete [] w[k][m];
        }
        
        delete [] dnet_dw[k];
        delete [] dw[k];
        delete [] finalDw[k];
        delete [] w[k];
    }
 
    
    delete [] dnet_dw;
    delete [] dw;
    delete [] finalDw;
    delete [] w;
}

//void SVCNNLayer::ProductWith(float*** inData,int row,int col)

float SVCNNLayer::sigmoid(float x)
{
    return 1.0 / (1.0 + exp(-x));
}
float SVCNNLayer::activate(float x)
{
//    return 1.0 / (1.0 + exp(-x));
    if(activeStyle == ActiveStyleRelu)
    {
        return relu(x);
    }
    else if(activeStyle == ActiveStyleRelu6)
    {
        return relu6(x);
    }
    else if(activeStyle == ActiveStyleRelu1)
    {
        return relu1(x);
    }
    else if(activeStyle == ActiveStyleLeakyRelu6)
    {
        return leakyRelu6(x);
    }
    else if(activeStyle == ActiveStyleSigmoid)
    {
        return sigmoid(x);
    }
    else if(activeStyle == ActiveStyleTanh)
    {
        return tanh(x);
    }
    else
    {
        return sigmoid(x);
    }
    
}
float SVCNNLayer::dactivate(float x)
{
//    return  x*(1-x);
    if(activeStyle == ActiveStyleRelu)
    {
        return dRelu(x);
    }
    else if(activeStyle == ActiveStyleRelu6)
    {
        return dRelu6(x);
    }
    else if(activeStyle == ActiveStyleRelu1)
    {
        return dRelu1(x);
    }
    else if(activeStyle == ActiveStyleSigmoid)
    {
        return dsigmoid(x);
    }
    else if(activeStyle == ActiveStyleLeakyRelu6)
    {
        return dLeakyRelu6(x);
    }
    else if(activeStyle == ActiveStyleTanh)
    {
        return dtanh(x);
    }
    else
    {
        return dsigmoid(x);
    }
    
}
float SVCNNLayer::leakyRelu6(float x)
{
    float r =  fmin(fmax(x, 0), 6);
    if(r == 0)
    {
        r = x/10.0;
    }
    return r;
}
float SVCNNLayer::dLeakyRelu6(float x)
{
    
    if(x == 0)
    {
        return 1/10.0;
    }
    else if(x == 6)
    {
           return 0;
    }
    else
    {
        return 1.0;
    }
}
float SVCNNLayer::relu6(float x){
    
    float r =  fmin(fmax(x, 0), 6); //ReLU6  see http://www.cs.utoronto.ca/~kriz/conv-cifar10-aug2010.pdf
    return r;
    
}
float SVCNNLayer::relu(float x){
    
    float r =  fmax(x, 0);
    return r;
    
}
float SVCNNLayer::relu1(float x)
{
    float r =  fmin(fmax(x, 0), 6);
    r = r/6;
    return r;
}
float SVCNNLayer::dRelu1(float x)
{
    if(x == 0 || x == 6)
    {
        return 0;
    }
    else
    {
        return 1.0/6;
    }
}
float SVCNNLayer::tanh(float x)
{
    float e1 = exp(x);
    float e2 = exp(-x);
    return (e1 - e2)/(e1 + e2);
   
}
float SVCNNLayer::dtanh(float x) {
    return 1.0 - x*x;
}
