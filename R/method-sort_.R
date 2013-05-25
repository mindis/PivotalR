
## ------------------------------------------------------------------------
## sort db.obj
## ------------------------------------------------------------------------

setGeneric ("sort")

setMethod (
    "sort",
    signature(x = "db.obj"),
    function (x, by = character(0), decreasing = FALSE, ...)
    {
        if (!is.character(by) || length(by) == 0
            !all(by %in% names(x)))
            stop("must sort by the column names!")
        if (decreasing)
            order <- "desc"
        else
            order <- ""

        sort <- list(by = by, order = order)

        if (is(x, "db.data.frame")) {
            content <- paste("select * from", content(x), "order by",
                             paste(by, collapse = ", "), order)
            expr <- names(x)
            src <- content(x)
            parent <- src
            where <- ""
        } else {
            content <- paste(content(x), "order by",
                             paste(by, collapse = ", "), order)
            expr <- x@.expr
            src <- x@.source
            parent <- x@.parent
            where <- x@.where
        }
        
        new("db.Rquery",
            .content = content,
            .expr = expr,
            .source = src,
            .parent = parent,
            .conn.id = conn.id(x),
            .col.name = names(x),
            .key = x@.key,
            .col.data_type = x@.col.data_type,
            .col.udt_name = x@.col.udt_name,
            .where = where,
            .is.factor = x@.is.factor,
            .sort = sort)
    },
    valueClass = "db.Rquery")