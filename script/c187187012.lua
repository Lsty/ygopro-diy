--少女強化武裝
function c187187012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c187187012.target)
	e1:SetOperation(c187187012.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c187187012.eqlimit)
	c:RegisterEffect(e3)
	--Replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95395761,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c187187012.reptg2)
	e4:SetOperation(c187187012.repop2)
	c:RegisterEffect(e4)
end
function c187187012.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187012.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c187187012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c187187012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c187187012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c187187012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c187187012.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget():IsReason(REASON_EFFECT+REASON_BATTLE)
		and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectYesNo(tp,aux.Stringid(95395761,1)) then
		e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c187187012.repop2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end