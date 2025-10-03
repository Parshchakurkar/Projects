
# Create a stage for building the application.
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000


FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG configuration=Release
WORKDIR /src
COPY . .
RUN dotnet restore Worker.csproj
RUN dotnet build Worker.csproj -c $configuration -o /app/build
RUN dotnet publish Worker.csproj -c $configuration -o /app/publish /p:UseAppHost=false


FROM base AS final

WORKDIR /app

# Copy everything needed to run the app from the "build" stage.
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "Worker.dll"]
