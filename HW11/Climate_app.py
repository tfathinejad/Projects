import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///titanic.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurments=Base.classes.measurment_table
Station=Base.classes.station_table

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Avalable Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"-the dates and precipitation observations from the last year<br/>"
        f"/api/v1.0/stations"
        f"- list of stations from the dataset<br/>"
        f"//api/v1.0/tobs"
        f"- list of Temperature Observations (tobs) for the previous year<br/>"
        f"/api/v1.0/calc_temps/<start>"
        f"- list of `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date<br/>"
        f"/api/v1.0/calc_temps/<start>/<end>"
        f"- the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive<br/>"
    )


@app.route("/api/v1.0/precipitation")
def precipitation():
    """Return a list of dates and precipitation observations"""
    # Query all dates and precipitation observations last year from the measurement table
    
    prcp_results = session.query(Measurments.date, Measurments.prcp).\
                   filter(Measurments.date.between('2016-08-01', '2017-08-01')).all()

    precipitation= []
    for result in prcp_results:
        row = {"date":"prcp"}
        row["date"] = result[0]
        row["prcp"] = float(result[1])
        precipitation.append(row)

    return jsonify(precipitation)


@app.route("/api/v1.0/stations")
def stations():
   
    # Query all stations from the station table
    station_results = session.query(Station.station, Station.station_name).group_by(Station.station).all()

    station_list = list(np.ravel(station_results))
    return jsonify(station_list)


@app.route("/api/v1.0/tobs")
def tobs():
    tobs_results = session.query(Measurments.station, Measurments.tobs).filter(Measurments.date.between('2016-08-01', '2017-08-01')).all()
    
    tobs_list=[]
    for tobs in tobs_results:
        tobs_dict = {}
        tobs_dict["station"] = tobs[0]
        tobs_dict["tobs"] = float(tobs[1])
       
        tobs_list.append(tobs_dict)
    return jsonify(tobs_list)

@app.route("/api/v1.0/calc_temps/<start>")

def calc_temps(start='start_date'):
    start_date = datetime.strptime('2016-08-01', '%Y-%m-%d').date()
    start_results = session.query(func.max(Measurments.tobs), \
                            func.min(Measurments.tobs),\
                            func.avg(Measurments.tobs)).\
                            filter(Measurments.date >= start_date) 
    
    start_tobs = []
    for tobs in start_results:
        tobs_dict = {}
        tobs_dict["TAVG"] = float(tobs[2])
        tobs_dict["TMAX"] = float(tobs[0])
        tobs_dict["TMIN"] = float(tobs[1])
        
        start_tobs.append(tobs_dict)

    return jsonify(start_tobs)
@app.route("/api/v1.0/calc_temps/<start>/<end>")

def calc_temps_2(start='start_date', end='end_date'):      
    start_date = datetime.strptime('2016-08-01', '%Y-%m-%d').date()
    end_date = datetime.strptime('2017-08-01', '%Y-%m-%d').date()

    start_end_results=session.query(func.max(Measurments.tobs).label("max_tobs"), \
                      func.min(Measurments.tobs).label("min_tobs"),\
                      func.avg(Measurments.tobs).label("avg_tobs")).\
                      filter(Measurments.date.between(start_date , end_date))   

    start_end_tobs = []
    for tobs in start_end_results:
        tobs_dict = {}
        tobs_dict["TAVG"] = float(tobs[2])
        tobs_dict["TMAX"] = float(tobs[0])
        tobs_dict["TMIN"] = float(tobs[1])

        start_end_tobs.append(tobs_dict)
    
    return jsonify(start_end_tobs)

if __name__ == '__main__':
    app.run(debug=True)
