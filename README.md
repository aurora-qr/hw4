# hw4. Interactive web service for PCA and CA analysis
#### Name: your name
#### ID: Student ID
#### ShinyApps link: your link

## Objective
- Create an interactive web service using ShinyApp to perform Principal Component Analysis (PCA) and Correspondence Analysis (CA).

<p align="center">
 <img src="/images/PCA.png" width="48%" height="48%" >
 <img src="/images/CA.png" width="48%" height="48%" >
<p/>

## Getting Started
1. **Integrate Example Script**: Integrating the following script into a Shiny application. While `ggbiplot` is recommended for creating biplots in PCA, feel free to explore and use other packages suitable for PCA and CA if necessary.

```R
data(iris)
# log transform 
log.ir <- log(iris[, 1:4])
ir.species <- iris[, 5]

# apply PCA - scale. = TRUE is highly advisable, but the default is FALSE. 
ir.pca <- prcomp(log.ir,center = TRUE, scale. = TRUE)

library(ggbiplot)
g <- ggbiplot(ir.pca, obs.scale = 1, var.scale = 1, groups = ir.species)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', legend.position = 'top')
print(g)
```

2.  **Installation of ggbiplot**: The `ggbiplot` package is not available on CRAN and must be installed from GitHub using the following command in RStudio:
```
devtools::install_github("vqv/ggbiplot")
```

3. **Connect Shinyapps.io with RStudio**:
   - In RStudio, manage your ShinyApps.io accounts by navigating to `Tools → Global Options → Publishing`. This setup is crucial for publishing your application.
     <p align="center">
     <img src="/images/shinyapp_on_rstudio.png" width="70%" height="70%" >
     <p/>   
 
   - Please organize your Shiny application using the following folder structure. Replace `110753xxx` with your actual student number.
```
110753xxx
   |-- 110753xxx.R
```

4. **Preview Your Application**: After completing your Shiny application, preview it in the RStudio console using the appropriate command to initiate your app locally.
```
library(shiny)
runApp("110753xxx")
```

5. **Publish**:
   - On the preview screen, locate the `Publish` button in the upper right corner. Click it to deploy your application to ShinyApps.io.
   - Ensure your application's title on ShinyApps.io follows this format: `NCCU_DS2024_hw4_studentID`.

<p align="center">
 <img src="/images/shinyapp_on_rstudio_2.png" width="60%" height="60%" >
<p/>

## Grading Criteria: Peer Evaluation

###  90 points: Base Tasks
- **30 points** Basic Information Display:
  - Display the following on the application's main page: `name`, `student number`.
  - Input data
- **30 points** PCA Analysis Web Application:
  - Develop a Shiny interactive web application to display PCA analysis for the Iris dataset. Users should be able to select which principal component (PC1, PC2, PC3, etc.) to view.
- **30 points** CA Analysis Web Application:
  - Develop a Shiny interactive web application to display CA for the Iris dataset.

### 10 points: Subjective Criteria
- **2 points** Aesthetics 🌷: Visually appealing interface.
- **2 points** Interactivity 🖥️: User-friendly and responsive interaction design.
- **2 points** Content Richness 📖: In-depth information and well-organized content.
- **up to 4 points** Additional Features: Each feature (listed below) is worth 2 points:
  - Detailed PCA results (e.g., variance explained)
  - ...

### Penalties

#### Peer Evaluation Non-Participation
- **-5 points** per unreviewed classmate: Failure to participate in the peer evaluation process will result in a deduction of 5 points for each classmate's work that is not evaluated.

#### Submission Requirements
- **-2 points** Missing ShinyApp Link and Student ID: Ensure your ShinyApp link and student ID are prominently displayed at the top of your `Readme.md`. A deduction of 2 points will apply if this information is missing.
- **-2 points** Inaccessible ShinyApp Link: Your project must be published on [shinyapps.io](https://www.shinyapps.io/) with an accessible public link. If the link is not accessible, 2 points will be deducted.
- **-2 points** Non-Compliant Title Format: The title of your ShinyApp must adhere to the format `NCCU_DS2024_hw4_studentID`. Failure to follow this format will result in a 2-point deduction.

Please make sure all required elements are correctly implemented to avoid these penalties.

## Important Notes
- **R Version**: Ensure you use R version 4 for this assignment.
- **No Makeup Assignments**: Late submissions will not be accepted.
- **Peer Evaluation Process**:
  - 5-6 randomly selected peers will evaluate each student's project.
  - The final score for each project will be the average of these evaluations.
  - Students are required to participate in evaluating others' projects; failure to do so will result in point deductions.
  - Peer evaluations will commence one week after the assignment due date.

## Examples
* #### https://changlab.shinyapps.io/ggvisExample/
* #### https://smalleyes.shinyapps.io/NCCU_DS2023_hw4_110753202/

## References
Please list the code and its reference, i.e., comment like # ChatGPT, respond to “your prompt,” on February 16, 2023.  
If your code is similar to others and lacks detailed comments, you may lose up to 10 points or possibly receive a zero.
