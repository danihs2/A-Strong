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