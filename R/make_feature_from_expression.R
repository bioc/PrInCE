#' Create a feature vector for a naive Bayes classifier from expression data
#' 
#' Convert a gene or protein expression matrix into a feature vector
#' that matches the dimensions of a data frame used as input to a classifier, 
#' such as a naive Bayes, random forests, or support vector machine classifier,
#' by calculating the correlation between each pair of genes or proteins.  
#' 
#' @param expr a matrix containing gene or protein expression data, with 
#' genes/proteins in columns and samples in rows
#' @param input the data frame of features to be used by the classifier, 
#' with protein pairs in the first two columns
#' @param ... arguments passed to \code{cor}
#' 
#' @return a vector matching the dimensions and order of the feature data frame,
#' to use as input for a classifier in interaction prediction 
#' 
#' @export
make_feature_from_expression <- function(expr, input, ...) {
  # get all proteins in feature data frame
  proteins_1 <- input[[1]]
  proteins_2 <- input[[2]]
  proteins <- unique(c(proteins_1, proteins_2))
  # subset expression to these proteins 
  filtered <- expr[, colnames(expr) %in% proteins]
  if (ncol(filtered) == 0)
    stop("no proteins overlap between expression and feature data")
  # create coexpression matrix
  coexpr <- cor(filtered, ...)
  # index matrix to get feature vector
  feat_idxs <- proteins_1 %in% rownames(coexpr) & 
    proteins_2 %in% rownames(coexpr)
  idxing_mat <- cbind(proteins_1[feat_idxs], proteins_2[feat_idxs])
  feature <- rep(NA, nrow(input))
  feature[feat_idxs] <- coexpr[idxing_mat]
  return(feature)
}