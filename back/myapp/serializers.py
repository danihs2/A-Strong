from rest_framework import serializers
from .models import GrupoMuscular, Ejercicio, Template, Historial, EjercicioHistorial

class GrupoMuscularSerializer(serializers.ModelSerializer):
    class Meta:
        model = GrupoMuscular
        fields = '__all__'

class EjercicioSerializer(serializers.ModelSerializer):
    idGrupoMuscular = serializers.PrimaryKeyRelatedField(
        queryset=GrupoMuscular.objects.all(), required=False, allow_null=True
    )
    
    class Meta:
        model = Ejercicio
        fields = '__all__'

# Luego, utiliza EjercicioSerializer en TemplateSerializer
class TemplateSerializer(serializers.ModelSerializer):
    ejercicios = EjercicioSerializer(many=True, read_only=True)
    ejercicio_ids = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Ejercicio.objects.all(), write_only=True
    )

    class Meta:
        model = Template
        fields = ['id', 'nombre', 'ejercicios', 'ejercicio_ids']

    def create(self, validated_data):
        ejercicios_data = validated_data.pop('ejercicios', [])
        template = Template.objects.create(**validated_data)
        
        for ejercicio_data in ejercicios_data:
            # Crea el Ejercicio asociado al Template
            Ejercicio.objects.create(
                template=template,
                **ejercicio_data
            )
        
        return template

    def update(self, instance, validated_data):
        ejercicio_ids = validated_data.pop('ejercicio_ids')
        instance.nombre = validated_data.get('nombre', instance.nombre)
        instance.save()
        instance.ejercicios.set(ejercicio_ids)
        return instance

class TemplateCreateSerializer(serializers.ModelSerializer):
    ejercicio_ids = serializers.ListField(child=serializers.IntegerField(), write_only=True)

    class Meta:
        model = Template
        fields = ['id', 'nombre', 'ejercicio_ids']

    def create(self, validated_data):
        ejercicio_ids = validated_data.pop('ejercicio_ids', [])
        print(f"Datos validados: {validated_data}")
        print(f"IDs de ejercicios: {ejercicio_ids}")
        
        template = Template.objects.create(**validated_data)
        for ejercicio_id in ejercicio_ids:
            try:
                ejercicio = Ejercicio.objects.get(id=ejercicio_id)
                template.ejercicios.add(ejercicio)
            except Ejercicio.DoesNotExist:
                print(f"Ejercicio con id {ejercicio_id} no encontrado.")
                raise serializers.ValidationError(f"Ejercicio con id {ejercicio_id} no encontrado.")
        
        print(f"Template creado: {template}")
        return template

# Serializer para EjercicioHistorial
class EjercicioHistorialSerializer(serializers.ModelSerializer):
    idEjercicio = serializers.PrimaryKeyRelatedField(queryset=Ejercicio.objects.all(), source='ejercicio')

    class Meta:
        model = EjercicioHistorial
        fields = ['id', 'idEjercicio', 'peso', 'repeticiones', 'tiempo_ejercicio']

class EjercicioHistorialSerializer2(serializers.ModelSerializer):
    idEjercicio = serializers.PrimaryKeyRelatedField(queryset=Ejercicio.objects.all(), source='ejercicio')
    nombreEjercicio = serializers.SerializerMethodField()

    class Meta:
        model = EjercicioHistorial
        fields = ['id', 'idEjercicio', 'nombreEjercicio', 'peso', 'repeticiones', 'tiempo_ejercicio']

    def get_nombreEjercicio(self, obj):
        return obj.ejercicio.nombre

# Serializer para Historial
class HistorialSerializer(serializers.ModelSerializer):
    idTemplate = serializers.PrimaryKeyRelatedField(queryset=Template.objects.all(), source='template')

    class Meta:
        model = Historial
        fields = ['id', 'idTemplate', 'fecha', 'tiempo_total']  # Asegúrate de usar 'tiempo_total'

# Serializer para manejar la creación completa de Historial y EjercicioHistorial
class HistorialCreateSerializer(serializers.Serializer):
    historial = HistorialSerializer()
    ejercicioHistorial = EjercicioHistorialSerializer(many=True)

    def create(self, validated_data):
        historial_data = validated_data.pop('historial')
        ejercicios_data = validated_data.pop('ejercicioHistorial')
        
        # Crear el historial
        historial = Historial.objects.create(**historial_data)
        
        # Crear los ejercicios_historial asociados
        for ejercicio_data in ejercicios_data:
            EjercicioHistorial.objects.create(historial=historial, **ejercicio_data)
        
        return historial  # Devuelve el historial creado
    


class HistorialSerializer(serializers.ModelSerializer):
    template = serializers.PrimaryKeyRelatedField(queryset=Template.objects.all())  # Usa el ID en lugar del objeto completo
    ejercicios_historial = EjercicioHistorialSerializer(many=True)

    class Meta:
        model = Historial
        fields = ['id', 'template', 'fecha', 'tiempo_total', 'ejercicios_historial']

class HistorialCompletoSerializer(serializers.ModelSerializer):
    # Incluir los detalles del historial
    template = serializers.StringRelatedField()  # O puedes usar TemplateSerializer si quieres más detalles
    ejercicios_historial = EjercicioHistorialSerializer2(many=True)

    class Meta:
        model = Historial
        fields = ['id', 'template', 'fecha', 'tiempo_total', 'ejercicios_historial']

    def to_representation(self, instance):
        # Esta función permite personalizar la estructura de salida del serializer
        representation = super().to_representation(instance)
        
        # Envolver en el formato deseado
        return {
            'historial': {
                'id': representation['id'],
                'template': representation['template'],
                'fecha': representation['fecha'],
                'tiempo_total': representation['tiempo_total'],
            },
            'ejercicios_historial': representation['ejercicios_historial']
        }
        