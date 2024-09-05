# Generated by Django 5.1.1 on 2024-09-05 02:51

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='GrupoMuscular',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre', models.CharField(max_length=100)),
                ('descripcion', models.TextField()),
                ('noImagen', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='Ejercicio',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre', models.CharField(max_length=100)),
                ('descripcion', models.TextField()),
                ('instrucciones', models.TextField()),
                ('unidad', models.CharField(choices=[('LBS', 'Libras'), ('MILE', 'Millas')], max_length=4)),
                ('tipo_medida', models.CharField(choices=[('REPS', 'Repeticiones'), ('TIME', 'Tiempo')], max_length=4)),
                ('grupo_muscular', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.grupomuscular')),
            ],
        ),
    ]