FROM mcr.microsoft.com/dotnet/aspnet:8.0 as base
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /src
ARG CONFIGURATION=Release
COPY ["RealworldAPI/RealworldAPI.csproj","RealworldAPI/"]
RUN dotnet restore "RealworldAPI/RealworldAPI.csproj"
COPY . .
WORKDIR "/src/RealworldAPI"
RUN dotnet publish "RealworldAPI.csproj" -c $CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM build AS final
COPY --from=build  /app/publish .
ENTRYPOINT [ "dotnet", "RealworldAPI.dll" ]
HEALTHCHECK CMD curl --fail http://localhost:8080/swagger/index.html || exit 1