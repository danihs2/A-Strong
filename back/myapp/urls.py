from django.urls import path
from .views import (
    GrupoMuscularListCreateView,
    GrupoMuscularDetailView,
    EjercicioListCreateView,
    EjercicioDetailView
)

urlpatterns = [
    # Rutas para Grupo Muscular
    path('grupos-musculares/', GrupoMuscularListCreateView.as_view(), name='grupo-muscular-list-create'),
    path('grupos-musculares/<int:pk>/', GrupoMuscularDetailView.as_view(), name='grupo-muscular-detail'),

    # Rutas para Ejercicio
    path('ejercicios/', EjercicioListCreateView.as_view(), name='ejercicio-list-create'),
    path('ejercicios/<int:pk>/', EjercicioDetailView.as_view(), name='ejercicio-detail'),
]
