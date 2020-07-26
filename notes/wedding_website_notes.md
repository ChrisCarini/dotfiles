#####################
Wedding Website Notes
#####################


Remove the bottom 'created with wordpress' crap
-----------------------------------------------

1. Appearance -> Theme Editor -> `footer.php`
1. Remove text so it looks like below:
    ```html
    <?php
    /**
     * The template for displaying the footer.
     *
     * Contains the closing of the #content div and all content after
     *
     * @package Button
     */
    
    ?>
    
        </div><!-- #content -->
    
    </div><!-- #page -->
    
    <?php wp_footer(); ?>
    
    </body>
    </html>
    ```

Remove 'Protected' from the `<title>` tag
-----------------------------------------
1. Appearance -> Theme Editor -> `functions.php`
1. Add the below in the `function button_setup() {` block
    ```html
    /*
     * Let's remove the "Protected:" crap from the page <title>
     */
    function filter_wp_title_remove_protected( $title ) {
        return str_replace("Protected:","",$title);
    }
    add_filter( 'pre_get_document_title', 'filter_wp_title_remove_protected', 10000000 );
    ```
   
References:
- https://wordpress.stackexchange.com/questions/194273/change-title-tag-dynamically-or-within-plugin
- https://wordpress.stackexchange.com/questions/305353/cant-change-the-title-tag-with-wp-title-filter
- https://developer.wordpress.org/reference/hooks/pre_get_document_title/
