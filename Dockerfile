#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["InvIntegrationLayer.csproj", "./"]
RUN dotnet restore "./InvIntegrationLayer.csproj"
COPY . .
WORKDIR "/src/InvIntegrationLayer"
RUN dotnet build "/src/InvIntegrationLayer.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "/src/InvIntegrationLayer.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "InvIntegrationLayer.dll"]