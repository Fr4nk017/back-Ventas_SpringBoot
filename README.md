# Innovatech Chile — Backend Ventas (Spring Boot)

Microservicio **Spring Boot** de gestión de ventas. Expone la API REST
`/api/v1/ventas` en el puerto **8080**. Parte del sistema Innovatech (EP3),
desplegado en **AWS ECS Fargate**.

La documentación de arquitectura, despliegue e infraestructura está centralizada
en el backend de despacho:
👉 **[backend-despacho/README.md](../backend-despacho/README.md)**

---

## API

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/api/v1/ventas` | Lista las ventas |
| GET | `/api/v1/ventas/{id}` | Obtiene una venta |
| POST | `/api/v1/ventas` | Crea una venta |
| PUT | `/api/v1/ventas/{id}` | Actualiza una venta |
| DELETE | `/api/v1/ventas/{id}` | Elimina una venta |

- Health check: `/actuator/health` · Swagger: `/swagger-ui.html`

---

## Variables de entorno

Inyectadas por la task definition de ECS (desde SSM Parameter Store, excepto `DB_NAME`):

| Variable | Origen | Valor |
|---|---|---|
| `DB_ENDPOINT` | SSM | endpoint del RDS |
| `DB_PORT` | SSM | `3306` |
| `DB_NAME` | task def | `ventasdb` |
| `DB_USERNAME` | SSM | `admin` |
| `DB_PASSWORD` | SSM (SecureString) | — |

---

## Build y ejecución

```bash
# Compilar (usa el wrapper de Maven incluido)
./mvnw clean package -DskipTests

# Docker (imagen multi-stage)
docker build -t ventas-backend .
docker run -p 8080:8080 \
  -e DB_ENDPOINT=... -e DB_PORT=3306 -e DB_NAME=ventasdb \
  -e DB_USERNAME=admin -e DB_PASSWORD=... ventas-backend
```

---

## CI/CD

`.github/workflows/deploy.yml`: build → push a ECR (`ventas-backend`) → deploy al
servicio `ventas-backend-svc` en ECS. Requiere los secrets `AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`.

La task definition de ECS está en [`.aws/task-definition.json`](.aws/task-definition.json).
