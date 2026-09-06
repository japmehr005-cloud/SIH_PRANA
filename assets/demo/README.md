# Aarogya demonstration datasets

Version: `demo-csv-v1`

These files are synthetic replay data. They are not clinical records and must remain labeled as simulation data.

Columns:

`timestamp_ms,hr_bpm,spo2,temp_c,accel_mag,gyro_mag,orientation_delta,movement,battery_pct,lat,lon`

Empty cells mean the sensor value is unavailable.

| File | Purpose |
|---|---|
| `normal.csv` | Resting samples for personal baseline |
| `flood_exertion.csv` | Higher heart rate with high movement during flood response |
| `health_deterioration.csv` | Rising heart rate, falling SpO2, irregular movement |
| `fall.csv` | Spike, impact, orientation change, then inactivity |
