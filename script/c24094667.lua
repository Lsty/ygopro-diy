--太阳花田
function c24094667.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_PLANT)
	c:RegisterEffect(e2)
	--attributes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
	--disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c24094667.tg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(24094667)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	if not c24094667.global_check then
		c24094667.global_check=true
		c24094667[0]=0
		c24094667[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c24094667.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(c24094667.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c24094667.tg(e,sc,sp,st)
	return c24094667[sp]>=1 and not (sc:IsAttribute(ATTRIBUTE_LIGHT) or sc:IsRace(RACE_PLANT))
end
function c24094667.checkop(e,tp,eg,ep,ev,re,r,rp)
	local s1=false
	local s2=false
	local tc=eg:GetFirst()
	while tc do
		if not (tc:IsAttribute(ATTRIBUTE_LIGHT) or tc:IsRace(RACE_PLANT)) then
			if tc:GetSummonPlayer()==0 then s1=true
			else s2=true end
		end
		tc=eg:GetNext()
	end
	if s1 then c24094667[0]=c24094667[0]+1 end
	if s2 then c24094667[1]=c24094667[1]+1 end
end
function c24094667.clear(e,tp,eg,ep,ev,re,r,rp)
	c24094667[0]=0
	c24094667[1]=0
end