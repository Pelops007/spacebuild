AddCSLuaFile( )

DEFINE_BASECLASS( "base_resource_generator" )

ENT.PrintName		= "Energy Generator"
ENT.Author			= "SnakeSVx"
ENT.Contact			= ""
ENT.Purpose			= "Testing"
ENT.Instructions	= ""

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:Initialize()
    BaseClass.Initialize(self)
    if SERVER then
        self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        -- Wake the physics object up. It's time to have fun!
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
        self.rdobject:addResource("energy", 0, 0)
        self.energygen = 8
        --self:PhysWake()
    end
end

function ENT:SpawnFunction(ply, tr)
    if (not tr.HitWorld) then return end

    local ent = ents.Create("resource_generator_energy")
    ent:SetPos(tr.HitPos + Vector(0, 0, 50))
    ent:Spawn()

    return ent
end


if SERVER then

    function ENT:getRate()

        local sunAngle = Vector(0,0,-1)
        local up = self:GetAngles():Up()
        local n = sunAngle:DotProduct(up*-1)

        if n >=0 then
            return self.energygen * n
        else return 0 end


    end

    function ENT:Think()
        self.rdobject:supplyResource("energy", self:getRate() or 0 )
        self:NextThink( CurTime() + 1 )
        return true
    end

end


