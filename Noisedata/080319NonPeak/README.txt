Export archive description

 meta.properties file are general info on device and record:
 - version_name Major, minor and revision version
 - build_date Date of APK assembly
 - version_number Application version integer
 - time_length Record length in seconds
 - uuid Random identifier set on first application start
 - leq_mean Mean equivalent sound level in dB(A) of the measure
 - record_utc Record time in epoch millisecond
 - device_manufacturer device_model device_product Generic Hardware information of measure device
 - pleasantness User input pleasantness 1-100
 - tags Comma separated values of user selected tags (english only)
 - user_profile User knowledge in acoustics NONE, NOVICE, EXPERT
 - noiseparty_tag Record NoiseParty identifier

 track.geojson 1s samples of measures. Using the geojson format (http://geojson.io)
 - leq_mean 1s mean equivalent sound level in dB(A)
 - accuracy Localisation precision in m (provided by gps, network or gsm)
 - location_utc Localisation fix time in epoch millisecond
 - leq_utc Measure time in epoch millisecond
 - leq_id Unique identifier of record
 - marker_color Color used by geojson.io
 - bearing Movement orientation.See https://developer.android.com/reference/android/location/Location.html#getBearing()
 - speed Estimated device speed in m/s
 - leq_frequency 1s mean equivalent sound level in dB(A) for the specified frequency
