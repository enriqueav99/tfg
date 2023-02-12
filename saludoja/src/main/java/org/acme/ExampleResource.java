package org.acme;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/saludo")
public class ExampleResource {

    @GET
    @Produces(MediaType.TEXT_HTML)
    public String hello() {
        return "<h1>Hola buenas esto es una prueba</h1>";
    }
}