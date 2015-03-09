--宝具 灿然辉耀的王剑
function c999999979.initial_effect(c)
	c:SetUniqueOnField(1,0,999999979)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999979.target)
	e1:SetOperation(c999999979.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c999999979.eqlimit)
	c:RegisterEffect(e3)
	--Atk,def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--Attribute Dark
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40410110,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c999999979.attcon)
	e6:SetOperation(c999999979.attop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c999999979.descon)
	e7:SetTarget(c999999979.destg)
	e7:SetOperation(c999999979.desop)
	c:RegisterEffect(e7)
end
function c999999979.eqlimit(e,c)
	return  c:IsCode(999999989)   or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999979.filter(c)
	return c:IsFaceup() and c:IsCode(999999989)  or c:IsCode(999999971)  or  c:IsCode(999999987) 
end
function c999999979.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999979.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999979.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999979.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999979.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999999979.attcon(e)
	local eg=e:GetHandler():GetEquipTarget()
	return eg:GetAttribute()~=ATTRIBUTE_DARK
end
function c999999979.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eg=c:GetEquipTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		eg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	    e2:SetRange(LOCATION_SZONE)
	    e2:SetCode(EVENT_BATTLE_DESTROYING)
	    e2:SetCondition(c999999979.hdcon)
	    e2:SetOperation(c999999979.hdop)
	    e2:SetReset(RESET_EVENT+0x1fe0000)
	    c:RegisterEffect(e2)
	end
end
function c999999979.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c999999979.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c999999979.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	return  e:GetHandler():IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY)
		and ec:IsLocation(LOCATION_GRAVE) and ec:GetReasonPlayer()==1-tp 
end
function c999999979.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil)  end
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c999999979.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end