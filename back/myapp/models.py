from django.db import models

class GrupoMuscular(models.Model):
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField()
    noImagen = models.IntegerField(null=True)

    def __str__(self):
        return self.nombre

class Ejercicio(models.Model):
    UNIDAD_OPCIONES = [
        ('LBS', 'Libras'),
        ('MILE', 'Millas'),
    ]

    TIPO_MEDIDA_OPCIONES = [
        ('REPS', 'Repeticiones'),
        ('TIME', 'Tiempo'),
    ]

    grupo_muscular = models.ForeignKey(GrupoMuscular, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField()
    instrucciones = models.TextField()
    unidad = models.CharField(max_length=4, choices=UNIDAD_OPCIONES)
    tipo_medida = models.CharField(max_length=4, choices=TIPO_MEDIDA_OPCIONES)
    noImagen = models.IntegerField(null=True)

    def __str__(self):
        return self.nombre

class Template(models.Model):
    nombre = models.CharField(max_length=100)
    ejercicios = models.ManyToManyField('Ejercicio')

    def __str__(self):
        return self.nombre

class Historial(models.Model):
    template = models.ForeignKey(Template, on_delete=models.CASCADE)
    fecha = models.DateTimeField(auto_now_add=True)
    tiempo_total = models.DecimalField(max_digits=6, decimal_places=2)  # Guarda el tiempo total, con 2 decimales de precisión
    
    def __str__(self):
        return f"Historial de {self.template.nombre} - {self.fecha}"

class EjercicioHistorial(models.Model):
    historial = models.ForeignKey(Historial, related_name='ejercicios_historial', on_delete=models.CASCADE)
    ejercicio = models.ForeignKey(Ejercicio, on_delete=models.CASCADE)
    peso = models.DecimalField(max_digits=5, decimal_places=2)  # Guarda el peso, con 2 decimales de precisión
    repeticiones = models.IntegerField()
    tiempo_ejercicio = models.DecimalField(max_digits=6, decimal_places=2,null=True, blank=True)  # Tiempo individual del ejercicio, opcional

    def __str__(self):
        return f"Historial de {self.ejercicio.nombre} - {self.historial.fecha}"