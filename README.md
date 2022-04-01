# Proxmox_Terraform_Infrastructure_as_Code

        ,--.           o    ||   |          |              
        |   |,---.    ,.,---||---|,---.,---.|    ,---.,---.
        |   |,---|\  / ||   ||   ||---'|   ||    |---'|    
        `--' `---^ `'  ``---'`   '`---'|---'`---'`---'`    
      --.--        |              |    |                   
        |,---.,---.|---.,---.,---.|    ,---.,---.,   .   
        ||---'|    |   ||   ||   ||    |   ||   ||   |   
        ``---'`---'`|  '`   '`---'`---'`---'`---|`---|   
        ,---.,---.,---|                     `---'`---'
        ,---||   ||   |                                    
        `---^`   '`---'                                    
        ,---.     |                   |    o               
        |---|.   .|--- ,---.,-.-.,---.|--- .,---.,---.     
        |   ||   ||    |   || | |,---||    ||   ||   |     
        `   '`---'`---'`---'` ' '`---^`---'``---'`   '     

## Pre-requirements:
- You need to have a working Proxmox environment
- You need to have a VM template (See https://github.com/DavidHepler/Proxmox_Packer_Templates)
- You need to have Terraform installed (see below for the Terraform installation)

## Terraform installation - see https://learn.hashicorp.com/tutorials/terraform/install-cli

### Linux
    #Steps 1 -3 performed with the Packer installation
    #(4) Install Terraform
    sudo apt-get update && sudo apt-get install terraform

### MacOS
    # skip brew hashicorp if you just installed Packer
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

