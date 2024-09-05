from rest_framework import viewsets
from .models import GrupoMuscular, Ejercicio
from .serializers import GrupoMuscularSerializer, EjercicioSerializer

class GrupoMuscularViewSet(viewsets.ModelViewSet):
    queryset = GrupoMuscular.objects.all()
    serializer_class = GrupoMuscularSerializer

class EjercicioViewSet(viewsets.ModelViewSet):
    queryset = Ejercicio.objects.all()
    serializer_class = EjercicioSerializer