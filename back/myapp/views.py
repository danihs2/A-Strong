from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from .models import GrupoMuscular, Ejercicio, Template, Historial
from .serializers import GrupoMuscularSerializer, EjercicioSerializer, TemplateSerializer, TemplateCreateSerializer, HistorialCreateSerializer, HistorialSerializer, HistorialCompletoSerializer

class GrupoMuscularViewSet(viewsets.ModelViewSet):
    queryset = GrupoMuscular.objects.all()
    serializer_class = GrupoMuscularSerializer

class EjercicioViewSet(viewsets.ModelViewSet):
    queryset = Ejercicio.objects.all()
    serializer_class = EjercicioSerializer

class TemplateViewSet(viewsets.ModelViewSet):
    queryset = Template.objects.all()
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return TemplateCreateSerializer
        return TemplateSerializer

class HistorialViewSet(viewsets.ModelViewSet):
    queryset = Historial.objects.all()

    def get_serializer_class(self):
        if self.action == 'create':
            return HistorialCreateSerializer  # Serializer para la creación
        return HistorialCompletoSerializer  # Serializer para la obtención de datos

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        historial = serializer.save()

        # Después de crear, utiliza un serializer estándar para la respuesta
        response_serializer = HistorialSerializer(historial)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)

