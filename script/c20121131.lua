--DevilScythe
function c20121131.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20121131.spcon)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20121131.spcon1)
	e2:SetOperation(c20121131.spop)
	c:RegisterEffect(e2)
	--xyzlimit1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c20121131.xyzlimit1)
	c:RegisterEffect(e3)
end
function c20121131.cfilter(c)
	return not c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER)
end
function c20121131.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,0)>0
		and not Duel.IsExistingMatchingCard(c20121131.cfilter,c:GetControler(),LOCATION_REMOVED,0,1,nil)
end
function c20121131.spcon1(e,c)
	return e:GetHandler():GetLevel()~=8
end
function c20121131.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(8)
	c:RegisterEffect(e1)
end
function c20121131.xyzlimit1(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WARRIOR)
end