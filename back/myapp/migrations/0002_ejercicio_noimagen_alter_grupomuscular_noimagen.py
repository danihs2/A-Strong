# Generated by Django 5.1.1 on 2024-09-05 04:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='ejercicio',
            name='noImagen',
            field=models.IntegerField(null=True),
        ),
        migrations.AlterField(
            model_name='grupomuscular',
            name='noImagen',
            field=models.IntegerField(null=True),
        ),
    ]
