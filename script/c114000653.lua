--★小人（ホムンクルス）の片割（かたわ）れ ラース
function c114000653.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(aux.Stringid(114000653,1))
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114000653.xyzcon)
	e2:SetOperation(c114000653.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114000653.reptg)
    c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c114000653.discon)
	e4:SetCost(c114000653.discost)
	e4:SetTarget(c114000653.distg)
	e4:SetOperation(c114000653.disop)
	c:RegisterEffect(e4)
end
--sp summon method 1
function c114000653.xyzfil(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and not c:IsType(TYPE_TOKEN)
end
--sp summom method 2
function c114000653.xyzfilter(c,slf)
	return c:IsSetCard(0x221)
	and c:GetLevel()>=5
	and c:IsFaceup()
	and not c:IsType(TYPE_TOKEN) 
	and c:IsCanBeXyzMaterial(slf,false)
end
function c114000653.xyzcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	local abcount=0
	if 4>ct then if Duel.CheckXyzMaterial(c,c114000653.xyzfil,7,4,4,nil) then abcount=abcount+1 end end
	if 3>ct then if Duel.IsExistingMatchingCard(c114000653.xyzfilter,c:GetControler(),LOCATION_MZONE,0,3,nil,c) then abcount=abcount+2 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end
function c114000653.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000653,3))
		sel=Duel.SelectOption(tp,aux.Stringid(114000653,0),aux.Stringid(114000653,1))+1
	end
	local mg
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	if sel==2 then
		mg=Duel.SelectMatchingCard(tp,c114000653.xyzfilter,tp,LOCATION_MZONE,0,3,5,nil,c)
	else
		mg=Duel.SelectXyzMaterial(tp,c,c114000653.xyzfil,7,4,4)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
function c114000653.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    local g=e:GetHandler():GetOverlayGroup()
    Duel.SendtoGrave(g,REASON_EFFECT)
	return true
end
--negate function
function c114000653.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
	and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
	and Duel.IsChainNegatable(ev)
end
function c114000653.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114000653.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c114000653.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(114000653,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end