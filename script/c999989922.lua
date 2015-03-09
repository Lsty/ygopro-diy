--宝具 幻想大剑·天魔失坠
function c999989922.initial_effect(c)
	c:SetUniqueOnField(1,0,999989922)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999989922.target)
	e1:SetOperation(c999989922.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999989922.eqlimit)
	c:RegisterEffect(e2)
	--Atk，def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(700)
	e4:SetCondition(c999989922.atkcon)
	c:RegisterEffect(e4)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64332231,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c999989922.destg2)
	e6:SetOperation(c999989922.desop2)
	c:RegisterEffect(e6)
end
function c999989922.eqlimit(e,c)
	return   c:IsCode(999989923)  or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999989922.filter(c)
	return c:IsFaceup() and   c:IsCode(999989923)  or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999989922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999989922.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999989922.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999989922.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999989922.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c999989922.atkcon(e,tp,eg,ep,ev,re,r,rp)
   local ec=e:GetHandler():GetEquipTarget()
	local ph=Duel.GetCurrentPhase()
	local dt=nil
	if ec==Duel.GetAttacker() then dt=Duel.GetAttackTarget()
	elseif ec==Duel.GetAttackTarget() then dt=Duel.GetAttacker() end
	return ec and ec:IsRelateToBattle() and (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (dt:IsRace(RACE_DRAGON)) 
end
function c999989922.dfilter(c)
	return c:IsFaceup() and  c:IsDefencePos() and c:IsDestructable() 
end
function c999989922.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c999989922.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c999989922.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c999989922.desop2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg1=Duel.GetMatchingGroup(c999989922.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg1,REASON_EFFECT)
end
