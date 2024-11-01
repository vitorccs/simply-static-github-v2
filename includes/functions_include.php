<?php
/**
 * Customization of "Simply Static" WordPress Plugin:
 *
 * Call a bash script which publishes the deployment files with Git CLI
 */
if ( ! function_exists( 'local_build_completed' ) ) {
    function local_build_completed()
    {
        shell_exec(ABSPATH . 'simply-static-github-v2/scripts/set_deploy.sh');
    }
}

add_action( 'ss_finished_transferring_files_locally', 'local_build_completed' );


