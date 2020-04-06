import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPRegressor
from sklearn.metrics import r2_score

#the following class will label encode data and scale it.
class Energy:
    
    def __init__(self, data):
        #this drop may need to be adjusted to remove unnecessary columns of data in the inserted data-set.
        self.data = data.drop(columns = data.columns[0:8], axis = 1)
        self.dtypes = dict(self.data.dtypes)
        
        
    def cleanData(self):
        # turn all zeros (zeros in this instance are effecively NaNs)
        # from data into the median value of their respective column.            
        for col in self.data.columns:
            #np.where only works on numpy arrays so we'll convert it and then 
            #send it back to a pandas dataframe.
            nparray = self.data[col].to_numpy() 
            nparray = np.where(self.data[col] == 0, None, self.data[col])
            self.data[col] = pd.DataFrame(nparray)
        
            #this chunk removes columns that contain no data (all zeros for example)
            if np.all(nparray == None):
                #inplace makes it so we don't have to type data = data.drop()
                self.data.drop(columns = col, inplace = True) 
        
        #the next couple chunks of code label encode the inserted data.
        str_cols = []        
        for n in range(len(self.data.columns)):
            if self.dtypes[self.data.columns[n]] == np.object: 
                str_cols.append(self.data.columns[n])
                                
        df = self.data[str_cols]  # isolate columns containing strings.
        df = df.apply(LabelEncoder().fit_transform)                       
        self.data[str_cols] = df  # return adjusted columns to working data set
        return self.data
        
        
    def normalize(self):
        #we want to normalize or scale the data in order to find which parameters
        #are affecting the cost of energy the most.
        self.data = self.data.fillna(self.data.median())
        x = self.data.values #returns a numpy array
        min_max_scaler = MinMaxScaler()
        x_scaled = min_max_scaler.fit_transform(x)
        data_scaled = pd.DataFrame(x_scaled, columns = self.data.columns)
        #data_scaled is both scaled and label encoded. 
        return data_scaled


if __name__ == "__main__":
    
#below you will include the url where the csv file is located and it will pull the
# data into this program.    

#    #albuquerque
#    alb_data = pd.read_csv(r"")
#    #atlanta
#    atl_data = pd.read_csv(r"")
#    #baltimore
#    blt_data = pd.read_csv(r"")
#    #houston
#    hst_data = pd.read_csv(r"")
#    #los angeles
#    la_data = pd.read_csv(r"")
#    #phoenix
#    phx_data = pd.read_csv(r"")
#    san francisco
#    sf_data = pd.read_csv(r"")
#    #seattle
#    sea_data = pd.read_csv(r"")
     
    #inside Energy() you will need to enter the name for the given data.
    energyValues = Energy(sf_data)
    newdata = energyValues.cleanData()
    #the finished data is what you will want to use in the machine learning algorithm.
    finished_data = energyValues.normalize()
    
    #below is the machine learning algorithm that will need to be adjust 
    #according to the data entered.
    
    #the predicting data should have the column that you are trying to predict entered into it
    #while the training data is the rest of the data used to help predict the predicting data
    #value.
#    training_data = finished_data[finished_data.columns[:-1]]
#    predicting_data = finished_data[finished_data.columns[-1]]
#    
#    data_train, data_test, target_train, target_test = train_test_split(
#            predicting_data, predicted_data, test_size = 0.3, train_size = 0.7)
#    
#    nCols = len(predicting_data.columns)
#    algorithm = MLPRegressor(hidden_layer_sizes = (nCols, nCols, nCols),
#                             max_iter = 500,
#                             learning_rate = 'adaptive')
#    
#    algorithm.fit(data_train, target_test)
#    
#    predictions = algorithm.predict(data_test)
#    #this is just an r squared test. The closer the value is to one the better it
#    #is at predicting.
#    r2_test = r2_score(target_test, predictions)
#    
#    print('R-Squared Score: ', r2_test, '(a good score is close to 1)')