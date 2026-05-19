import math
import pickle
import pandas as pd
import numpy as np
from pathlib import Path

import settings

with open(Path(settings.pickle_path) / "dtc.pickle", "rb") as pickle_model:
    model = pd.read_pickle(pickle_model)

def score(Age, WorkClass, Education, MartialStatus, Relationship, Race, Sex, HoursPerWeek):
    "Output: EM_CLASSIFICATION, EM_EVENTPROBABILITY"

    try:
        global model
    except NameError:
        with open(Path(settings.pickle_path) / "dtc.pickle", "rb") as pickle_model:
            model = pd.read_pickle(pickle_model)


    index=None
    if not isinstance(Age, pd.Series):
        index=[0]
    input_array = pd.DataFrame(
        {"Age": Age, "WorkClass": WorkClass, "Education": Education, "MartialStatus":
        MartialStatus, "Relationship": Relationship, "Race": Race, "Sex": Sex,
        "HoursPerWeek": HoursPerWeek}, index=index
    )
    input_array = preprocess_function(input_array)
    prediction = model.predict_proba(input_array).tolist()

    # Check for numpy values and convert to a CAS readable representation
    if isinstance(prediction, np.ndarray):
        prediction = prediction.tolist()

    if input_array.shape[0] == 1:
        if prediction[0][1] > 0.5:
            EM_CLASSIFICATION = "1"
        else:
            EM_CLASSIFICATION = "0"
        return EM_CLASSIFICATION, prediction[0][1]
    else:
        df = pd.DataFrame(prediction)
        proba = df[1]
        classifications = np.where(df[1] > 0.5, '1', '0')
        return pd.DataFrame({'EM_CLASSIFICATION': classifications, 'EM_EVENTPROBABILITY': proba})
def preprocess_function(df):
    cat_vals = df[["WorkClass", "Education", "MartialStatus", "Relationship", "Race", "Sex"]]
    df = pd.get_dummies(df, columns=["WorkClass", "Education", "MartialStatus", "Relationship", "Race", "Sex"])
    df.columns = df.columns.str.replace(' ', '')
    df.columns = df.columns.str.replace('-', '_')
    df = df.drop(['Sex_Male'], axis=1)
    if 'index' in df.columns or 'index' in cat_vals.columns:
        df = pd.concat([df, cat_vals], axis=1).drop('index', axis=1)
    # For the model to score correctly, all OHE columns must exist
    input_cols = [
        "Education_9th", "Education_10th", "Education_11th", "Education_12th", "Education_Assoc_voc", "Education_Assoc_acdm", "Education_Masters", "Education_Prof_school",
        "Education_Doctorate", "Education_Preschool", "Education_1st_4th", "Education_5th_6th", "Education_7th_8th", "WorkClass_Self_emp_inc", "WorkClass_Self_emp_not_inc",
        "WorkClass_Federal_gov", "WorkClass_Local_gov", "WorkClass_State_gov", "WorkClass_Without_pay", "WorkClass_Never_worked", "MartialStatus_Married_spouse_absent",
        "MartialStatus_Married_AF_spouse", 'MartialStatus_Married_civ_spouse', 'MartialStatus_Never_married', 'MartialStatus_Divorced', 'MartialStatus_Separated', 
        'MartialStatus_Widowed', 'Race_White', 'Race_Black', 'Race_Asian_Pac_Islander', 'Race_Amer_Indian_Eskimo', 'Race_Other', 'Relationship_Husband', 
        'Relationship_Not_in_family', 'Relationship_Own_child', 'Relationship_Unmarried', 'Relationship_Wife', 'Relationship_Other_relative', 'WorkClass_Private',
        'Education_Bachelors', 'Education_Some_college', 'Education_HS_grad'
    ]
    # OHE columns must be removed after data combination
    predictor_columns = ['Age', 'HoursPerWeek', 'WorkClass_Private', 'WorkClass_Self', 'WorkClass_Gov', 
       'WorkClass_Other', 'Education_HS_grad', 'Education_Some_HS', 'Education_Assoc', 'Education_Some_college',
       'Education_Bachelors', 'Education_Adv_Degree', 'Education_No_HS', 'MartialStatus_Married_civ_spouse',
       'MartialStatus_Never_married', 'MartialStatus_Divorced', 'MartialStatus_Separated', 'MartialStatus_Widowed',
       'MartialStatus_Other', 'Relationship_Husband', 'Relationship_Not_in_family', 'Relationship_Own_child', 'Relationship_Unmarried',
       'Relationship_Wife', 'Relationship_Other_relative', 'Race_White', 'Race_Black', 'Race_Asian_Pac_Islander',
       'Race_Amer_Indian_Eskimo', 'Race_Other', 'Sex_Female']

    for col in input_cols:
        if col not in df.columns:
            df[col] = 0


    df["Education_Some_HS"] = df["Education_9th"] | df["Education_10th"] | df["Education_11th"] | df["Education_12th"]
    df["Education_Assoc"] = df["Education_Assoc_voc"] | df["Education_Assoc_acdm"]
    df["Education_Adv_Degree"] = df["Education_Masters"] | df["Education_Prof_school"] | df["Education_Doctorate"]
    df["Education_No_HS"] = df["Education_Preschool"] | df["Education_1st_4th"] | df["Education_5th_6th"] | df["Education_7th_8th"]

    df["WorkClass_Self"] = df["WorkClass_Self_emp_inc"] | df["WorkClass_Self_emp_not_inc"]
    df["WorkClass_Gov"] = df["WorkClass_Federal_gov"] | df["WorkClass_Local_gov"] | df["WorkClass_State_gov"]
    df["WorkClass_Other"] = df["WorkClass_Without_pay"] | df["WorkClass_Never_worked"]

    df["MartialStatus_Other"] = df["MartialStatus_Married_spouse_absent"] | df["MartialStatus_Married_AF_spouse"]

    df = df[predictor_columns]

    return df
