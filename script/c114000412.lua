--★不死の軍団（マネキン・ソルジャー）
function c114000412.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c114000412.xyzcon)
	e1:SetOperation(c114000412.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--xyz summon method2
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetDescription(aux.Stringid(114000412,1))
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(c114000412.xyzcon)
	--e2:SetOperation(c114000412.xyzop)
	--e2:SetValue(SUMMON_TYPE_XYZ)
	--c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c114000412.reptg)
	c:RegisterEffect(e3)
end
--sp summon method 1
function c114000412.xyzfil(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) --and c:GetLevel()==4 
end
--sp summom method 2
function c114000412.xyzfilter(c,slf)
	return c:IsSetCard(0x221)
	and c:GetLevel()>0 
	and c:IsFaceup()
	and not c:IsType(TYPE_TOKEN) and c:IsCanBeXyzMaterial(slf,false)
end
function c114000412.xyzcon(e,c)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=0 and Duel.IsExistingMatchingCard(c114000412.xyzfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c) then abcount=abcount+2 end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	--if 2<=ct then return false end
	if ct<2 then if Duel.CheckXyzMaterial(c,c114000412.xyzfil,4,2,2,nil) then abcount=abcount+1 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114000412.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000412,2))
		sel=Duel.SelectOption(tp,aux.Stringid(114000412,0),aux.Stringid(114000412,1))+1
	end
	local mg
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	if sel==2 then
		mg=Duel.SelectMatchingCard(tp,c114000412.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	else
		mg=Duel.SelectXyzMaterial(tp,c,c114000412.xyzfil,4,2,2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
--destroy replace
function c114000412.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	local c=e:GetHandler()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end