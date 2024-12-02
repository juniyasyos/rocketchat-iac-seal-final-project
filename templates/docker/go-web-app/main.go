package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
	
)

func handler(w http.ResponseWriter, r *http.Request) {
    message := os.Getenv("HELLO_MESSAGE")
    if message == "" {
        message = "Hello, World!"
    }
    fmt.Fprintf(w, message)
}

func main() {
    http.HandleFunc("/", handler)
    log.Println("Starting server on :8080")
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalf("Could not start server: %s\n", err.Error())
    }
}
