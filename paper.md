---
title: 'TAGS: RShiny App for Light-level Geolocator Data Cleaning and Annotation'
tags:
  - R
  - biology
  - geolocator
  - animal tracking
  - data cleaning
authors:
  - name: Claire M. Curry^[Co-first author, corresponding author]
    orcid: 0000-0003-4649-7537
    affiliation: "1, 2" 
  - name: Eli S. Bridge^[Co-first author]
    orcid: 0000-0003-3453-2008
    affiliation: 2
affiliations:
 - name: University Libraries, University of Oklahoma, USA
   index: 1
 - name: Oklahoma Biological Survey, University of Oklahoma, USA
   index: 2

date: 20 March 2025
bibliography: paper.bib

---

# Summary

## " Summary: Has a clear description of the high-level functionality and purpose of the software for a diverse, non-specialist audience been provided?"- https://joss.readthedocs.io/en/latest/review_criteria.html


Studies of avian migration frequently entail the use of tracking devices to map the movements of birds in space and time [@bridgeTechnologyMoveRecent2011]. Of the several types of tracking devices available, the smallest are light-level geolocation dataloggers. These devices may weigh less than 1 gram and are used to track birds that are too small to carry devices like GPS-enabled transmitters or cellular-based trackers [@bridgeTechnologyMoveRecent2011]. Geolocators are also inexpensive relative to other tracking devices [@bridgeTechnologyMoveRecent2011], and thus can be deployed in large numbers. By simply recording light levels at short time intervals, geolocators provide estimates of the time of sunrise and sunset, which in turn allows one to infer latitude (based on day length) and longitude (based on the time of solar noon) [@delongDocumentingMigrationsNorthern1992; @wilsonEstimationLocationGlobal1992; @hillTheoryGeolocationLight1994]. Although this tracking method is limited by the fact that the tracked animal must be recaptured to recover the tag, geolocators have revolutionized our understanding of avian migration [@stutchburyTrackingLongDistanceSongbird2009; @bridgeTechnologyMoveRecent2011; @mckinnonNewDiscoveriesLandbird2013; @lisovskiLightlevelGeolocatorAnalyses2020].

![Sunlight distribution map and simulated geologger data illustrating solar-geolocation based on daylength (indicates latitude) and the time of solar noon (indicates logitude).  The bars for solar noon and day length are over a shaded map of the world indicating what area of the globe is currently in daylight.  The site where the two bars cross is the geolocation for that combination of solar noon and day length.](Figure1-polished_arrangement.svg?raw=true "How sunlight is used to calculate latitude and longitude") 
<figcaption align = "left"><b>Fig. 1 Sunlight distribution map and simulated geologger data illustrating solar-geolocation based on daylength (indicates latitude) and the time of solar noon (indicates logitude).  The bars for solar noon and day length are over a shaded map of the world indicating what area of the globe is currently in daylight.  The site where the two bars cross is the geolocation for that combination of solar noon and day length.  The two red data points on the lower panel indicate noisy readings, potentially caused by artifical light or natural shading.</b></figcaption>
<br>

</br>
Transforming light level data from a geolocator into geographical coordinates requires several analytical steps [@lisovskiLightlevelGeolocatorAnalyses2020]. The first step generally involves visualizing the data and editing instances where light level values have apparently been altered by shading or other interference [@lisovskiGeoLightProcessingAnalysing2012]. TAGS provides a user-friendly platform for performing this crucial first step in the analysis of geolocator data. The software provides a simple visual interface for displaying tag data and “zooming in” on problem areas. It also allows for data editing through an annotation process such that changes made to the dataset are tracked, making the entire analysis process reproducible. As the users edit their data they can create preliminary maps to see their migratory flight paths take shape. Finally, the output from TAGS is compatible with all of the next steps in geolocator analysis: R packages such as `FLightR` [@rakhimberdievFLightRPackageReconstructing2017], `GeoLight` [@lisovskiGeoLightProcessingAnalysing2012], and `SGAT` [@sumnerBayesianEstimationAnimal2009; @lisovskiGeoLightProcessingAnalysing2012], which  are accepted as standards for generating publishable results from geolocator data [@lisovskiLightlevelGeolocatorAnalyses2020]. 

# Statement of need

`TAGS: Totally Awesome Geolocator Service` is an RShiny wrapper and functionality extension for the data cleaning functionality from the `GeoLight` R package [@lisovskiGeoLightProcessingAnalysing2012].  It provides additional functionality with its point-and-click interface and data annotation for repeatability.  It is one of the six major recommended open-source tools for light-level geolocator data analysis [@lisovskiLightlevelGeolocatorAnalyses2020].  It takes data in three common formats (.csv, .lig, and .lux), then outputs data into a now-standard format that is compatible with standard geolocator analysis packages such as `FLightR` [@rakhimberdievFLightRPackageReconstructing2017], `GeoLight` [@lisovskiGeoLightProcessingAnalysing2012], and `SGAT` [@sumnerBayesianEstimationAnimal2009; @lisovskiGeoLightProcessingAnalysing2012].  

# State of the field

## "State of the field: Do the authors describe how this software compares to other commonly-used packages?"- https://joss.readthedocs.io/en/latest/review_criteria.html Mention (if applicable) a representative set of past or ongoing research projects using the software and recent scholarly publications enabled by it.


This package is designed to be used by researchers with messy light-level geolocator data.  The software is featured in has been recently featured as one of the six major tools in the analysis workflow for geolocators [@lisovskiLightlevelGeolocatorAnalyses2020] who note TAGS can "visualize the raw light-level recordings with different zoom options, fast processing and a  user-friendly interface that does not require users to write code".  @lisovskiLightlevelGeolocatorAnalyses2020 notes in Table 1 that TAGS is the only major geolocator data processing tool that does not require users to write code.  

The TAGS format documents the changes made to the dataset for repeatability with a new column.  Thus, users can run analyses with and without the edited points, which is a functionality not available in the original `GeoLight` package's data cleaning feature (argument ask = TRUE within the twilightCalc() function).  Unlike TAGS, `GeoLight`'s interactive cleaning process does not allow the user to move backwards in the dataset, only forward.  Additiponally, in TAGS the user can click and drag to select multiple points; in `GeoLight` the user can select only one point at a time.  `GeoLight`::twilightCalc was last updated in 2022.  Like `GeoLight`, `TwGeos` similarly uses the R interactive interface, but requires coding to import the data and provides only keyboard navigation (and thus memorization) to make edits and annotations [@Lisovski:2016] in the preprocessLight() function. `TwGeos`::preprocessLight() has not been updated since 2019.  For .lig data, the BAS TransEdit program [@Fox:2009] can be used, but it is closed-source and not available for all data types.  For research groups with less-experienced members such as undergraduates who are just being introduced  to data cleaning, the user-friendliness, efficiency, and reproducibility of TAGS are particularly important.

TAGS has been cited in methods [@continaUsingGeologgersInvestigate2013; @rakhimberdievHiddenMarkovModel2015; @johnsonDichotomousStrategiesMigration2016; @pierceMigrationRoutesTiming2017] and recommended for use [@lisovskiLightlevelGeolocatorAnalyses2020] since its creation.  Other packages, such as `TwGeos` and `FLightR`, include functions to export to a TAGS-compatible format (the export2TAGS() and GeoLight2TAGS() functions, respectively).  The project previously existed as a [JavaScript-based web interface debuting in 2013](https://github.com/tags/geologgerui).  The application was re-written in RShiny in 2018-2020 to enable ongoing modification to use the interface with additional data cleaning packages for geolocator data in R.  Most biologists using geolocators are using R and thus may be able to translate their favorite  with most efficiency to the RShiny interactive interace.  Existing GitHub issues suggest current feature requests.  The code base is commented to indicate where future contributes can extend the project with additional geolocator data cleaning packages while still maintaining the annotated (and thus reproducible), cleaned TAGS output format.  The redesigned tool was debuted to practitioners at a geolocator-specific animal tracking workshop for the International Ornithological Congress in Vancouver BC in 2018.  

Citations and needs to address in paper: https://github.com/openjournals/joss/issues/1031
Other wrappers to compare to see if we meet scope:
- https://joss.theoj.org/papers/10.21105/joss.01160
- Other wrappers: https://joss.theoj.org/papers/search?q=wrapper


# Acknowledgements

We thank Simeon Lisovski for comments on TAGS and guidance in adapting the R Geolight package; Anne Scharf and Andrea Koelzsch for help adapting the app to MoveApps; Jonah Duckles and Phil Dow for contributions to a previous version of TAGS in JavaScript; Paula Cimprich for selecting example data; and Wes Honeycutt for comments on the manuscript. The original development of this software was supported by USDA grant number (find TODO)

# References

::: {#refs}
:::