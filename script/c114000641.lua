--★小人（ホムンクルス）の片割（かたわ）れ ラスト
function c114000641.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114000641.xyzcon)
	e2:SetOperation(c114000641.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114000641.reptg)
    c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
--sp summon method 1
function c114000641.xyzfil(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
--sp summom method 2
function c114000641.xyzfilter(c,slf)
	return c:IsSetCard(0x221)
	and c:GetLevel()>0 
	and c:IsFaceup()
	and not c:IsType(TYPE_TOKEN) 
	and c:IsCanBeXyzMaterial(slf,false)
end
function c114000641.xyzcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	local abcount=0
	if 3>ct then if Duel.CheckXyzMaterial(c,c114000641.xyzfil,4,3,3,nil) then abcount=abcount+1 end end
	if 2>ct then if Duel.IsExistingMatchingCard(c114000641.xyzfilter,c:GetControler(),LOCATION_MZONE,0,2,nil,c) then abcount=abcount+2 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end
function c114000641.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000641,2))
		sel=Duel.SelectOption(tp,aux.Stringid(114000641,0),aux.Stringid(114000641,1))+1
	end
	local mg
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	if sel==2 then
		mg=Duel.SelectMatchingCard(tp,c114000641.xyzfilter,tp,LOCATION_MZONE,0,2,5,nil,c)
	else
		mg=Duel.SelectXyzMaterial(tp,c,c114000641.xyzfil,4,3,3)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
function c114000641.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end