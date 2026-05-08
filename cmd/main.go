package main

import (
	"fmt"
	"net/http"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func health(writer http.ResponseWriter, request *http.Request) {
	writer.WriteHeader(http.StatusOK)
	fmt.Fprintf(writer, "ok")
}

func main() {
	http.HandleFunc("/health", health)
	http.Handle("/metrics", promhttp.Handler())

	fmt.Println("Health check on localhost:4123/health")
	fmt.Println("Prometheus metrics on localhost:4123/metrics")
	err := http.ListenAndServe(":4123", nil)
	if err != nil {
		fmt.Println("Starting error: ", err)
	}
}
