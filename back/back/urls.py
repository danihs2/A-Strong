from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from myapp.views import GrupoMuscularViewSet, EjercicioViewSet

# Configurar el router
router = DefaultRouter()
router.register(r'grupos-musculares', GrupoMuscularViewSet)
router.register(r'ejercicios', EjercicioViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),  # Usar router para API root
]
