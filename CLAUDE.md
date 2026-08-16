# App de Ahorro

Seguidor de objetivos de ahorro. **Un solo archivo**: `ahorro.html`, ~3200 líneas,
sin dependencias, sin build. Se abre con doble clic. Los datos viven en localStorage
del navegador, no en el archivo.

## Regla número uno: commitear antes de tocar

**Antes de cualquier edición grande, hacer un commit.** Ya se perdieron 1800 líneas una
vez por un script de limpieza que borró de más, y solo se recuperaron de casualidad
porque el navegador tenía una copia en memoria.

```bash
git add -A && git commit -m "punto de guardado antes de <lo que sea>"
```

Y al terminar la tanda, otro commit con lo que se hizo.

## Nunca borrar bloques buscando comentarios

El desastre vino de un `s.index('/* ---- fechas de oportunidad ---- */')` que encontró
el marcador en el CSS en vez de en el JS y se llevó todo lo del medio. Si hay que
eliminar un bloque: usar la herramienta de edición con el texto exacto y completo,
nunca cortar por índices de marcadores que pueden repetirse. Y si igual se usa un
script, verificar después que las funciones clave sigan existiendo:

```bash
for f in compute heroHTML itemsHTML movHTML chartHTML render wire; do
  printf "%-12s %s\n" "$f" "$(grep -c "function $f" ahorro.html)"
done
```

## Decisiones de diseño que no se tocan

1. Los aportes se cargan en dólares y quedan congelados. La cotización del BNA es solo
   decorativa: muestra el equivalente en pesos, no entra en ningún cálculo de progreso.
2. Los ítems se llenan en cascada, en el orden que elige el usuario.
3. Marcar un ítem como comprado lo saca del total y descuenta su precio del saldo.
   **Invariante: "cuánto me falta" da exactamente igual antes y después.**
4. El sueldo es **global** (`state.settings.sueldo`) y se reparte entre objetivos por
   porcentaje (`objetivo.pctSueldo`). Los confirmados se guardan con
   `excludeFromRate:true` y los futuros se suman aparte en la proyección, para no
   contarlos dos veces.
5. El ritmo se mide sobre una ventana anclada en los aportes del usuario (mínimo 28
   días, máximo 120), nunca sobre semanas de calendario.
6. Los días que "te adelantó/atrasó" un movimiento se congelan en `m.diasPlan` al
   cargarlo. No se recalculan después.
7. El modo prueba usa una caja de datos separada (`ahorro_prueba_v1`), copia los datos
   reales al entrar, y **no se recuerda entre sesiones**.

## Compatibilidad de datos

Cualquier campo nuevo va también en `normalize()`, con su valor por defecto. Los
backups viejos (v1, v2) tienen que seguir cargando. La migración del sueldo por
objetivo al sueldo global vive ahí.

## Cómo verificar

Abrir el archivo en un navegador y ejercitar de verdad, no razonar leyendo. En consola
se puede pisar `fakeToday` para viajar en el tiempo, armar objetivos con
`normalize({objectives:[...], activeId:'x'})` y llamar a `compute()`. Para probar
persistencia hay que reemplazar `localStorage` por un objeto en memoria: en algunos
contextos el navegador lo bloquea y los tests pasan en falso.

Antes de dar algo por terminado: consola sin errores, invariante de compra, backups
viejos por `normalize`, y el gráfico en los extremos (zoom mínimo, pan en las cuatro
direcciones, objetivo vencido).

## Idioma

Todo en español rioplatense: interfaz, comentarios y mensajes de commit.
