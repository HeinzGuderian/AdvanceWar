import UnityEngine

class NotFoundException (System.Exception): 
    def constructor(message):
        super("Error: " + message + " not found.")