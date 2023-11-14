#!/bin/python3
import os, sys, getopt, shutil

class Build:
    @staticmethod
    def build(flavour):
        for dir in os.listdir("docker/"+flavour):
            print("Building cf3005/ctdc-"+flavour+":"+dir)
            os.system("docker buildx build --push --platform amd64 --platform arm64  -t cf3005/ctdc-base"+":"+dir+" ./docker/"+flavour+"/"+dir)

class Template:
    @staticmethod
    def new(name):
        os.makedirs("templates/"+name,755,exist_ok=True)
        os.makedirs("templates/"+name+"/build",755,exist_ok=True)
        shutil.copyfile("templates/Base/main.tf", "templates/"+name+"/main.tf")
        shutil.copytree("templates/Base/build", "templates/"+name+"/build")

    @staticmethod
    def sync(template):
        if template == "all":
            print("Syncing all")
            for dir in os.listdir("templates"):
                print("Syncing "+dir)
                if dir != "Base":
                    shutil.copyfile("templates/Base/main.tf", "templates/"+dir+"/main.tf")
        else:
            print("Syncing "+template)
            shutil.copyfile("templates/Base/main.tf", "templates/"+template+"/main.tf")

    def push(template,update = False):
        if template == "all":
            print("Pushing all")
            for dir in os.listdir("templates"):
                print("Pushing "+dir)
                os.system("cd templates/"+dir+" && terraform init "+("-upgrade" if update else "")+" && terraform validate && coder template push --yes --name=$(openssl rand -hex 8)")
        else:
            print("Pushing "+template)
            os.system("cd templates/"+template+" && terraform init "+("-upgrade" if update else "")+" && terraform validate && coder template push --yes --name=$(openssl rand -hex 8)")


match sys.argv[1]:
    case "docker":
        match sys.argv[2]:
            case "build":
                Build.build(sys.argv[3])
    case "template":
        match sys.argv[2]:
            case "new":
                Template.new(sys.argv[3])
            case "sync":
                Template.sync(sys.argv[3])
            case "push":
                Template.push(sys.argv[3],sys.argv[4] == "--update" or sys.argv[4] == "-u" if len(sys.argv) > 4 else False)