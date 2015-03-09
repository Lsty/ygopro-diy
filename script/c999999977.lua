--传说之王 亚瑟王 阿尔托利亚·潘德拉贡
function c999999977.initial_effect(c)
   c:SetUniqueOnField(1,0,999999977)
   --xyz summon
   aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999999977.xyzfilter),8,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c999999977.stg)
	e1:SetOperation(c999999977.sop)
	c:RegisterEffect(e1)
    --cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
     --[[--special xyz_summon 
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(999998,12))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c999999977.spcon)
	e3:SetOperation(c999999977.spop)
	c:RegisterEffect(e3)--]]
    --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetTarget(c999999977.distg)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c999999977.disop)
	c:RegisterEffect(e5)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_SZONE)
	e6:SetTarget(c999999977.distg)
	c:RegisterEffect(e6)
   --[[ --actlimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetOperation(c999999977.operation)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e8)--]]
    --negate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(999997,2))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetHintTiming(0,0x1e0)
	--e9:SetCondition(c999999977.negcon)--
	e9:SetCost(c999999977.negcost)
	e9:SetTarget(c999999977.negtg)
	e9:SetOperation(c999999977.negop)
	c:RegisterEffect(e9)
    --[[change  target
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(999997,3))
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BE_BATTLE_TARGET)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c999999977.cbcon)
	e10:SetOperation(c999999977.cbop)
	c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(999997,3))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c999999977.ctcon)
	e11:SetTarget(c999999977.cttg)
	e11:SetOperation(c999999977.ctop)
	c:RegisterEffect(e11)--]]
end
function c999999977.xyzfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999977.eqfilter(c)
	return c:IsCode(999999981) 
end
function c999999977.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return   chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and c999999977.eqfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and 
	Duel.IsExistingTarget(c999999977.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e:GetHandler())  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectTarget(tp,c999999977.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999977.sfilter(c)
	return c:IsCode(999999984) and c:IsAbleToHand()
end
function c999999977.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFirstTarget()
	 if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if g1:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,g1,c)
	end
	if Duel.IsExistingMatchingCard(c999999977.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	and  Duel.SelectYesNo(tp,aux.Stringid(999999,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999999977.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g2 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
--[[function c999999977.ovfilter1(c)
	return c:IsSetCard(0x998)
end
function c999999977.ovfilter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c999999977.spcon(e,c)
	if  Duel.IsExistingMatchingCard(c999999977.ovfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil) and
	Duel.IsExistingMatchingCard(c999999977.ovfilter2,e:GetHandlerPlayer(),LOCATION_SZONE+LOCATION_HAND,0,2,nil) then return true
	else return false end
end
function c999999977.spop(e,tp,eg,ep,ev,re,r,rp,c)	
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c999999977.ovfilter2,e:GetHandlerPlayer(),LOCATION_SZONE+LOCATION_HAND,0,2,2,nil)
	local g2=Duel.SelectMatchingCard(tp,c999999977.ovfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g1:GetCount()==2 and g2:GetCount()==2 then
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
    Duel.Overlay(c,g2)
end
end--]]
function c999999977.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or not c:IsType(TYPE_SPELL) or c:GetCardTargetCount()==0 then return false end
	return  c:GetControler()~=ec:GetControler() and c:GetCardTarget():IsContains(ec)
end
function c999999977.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not re:IsActiveType(TYPE_SPELL) then return end
	if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not rp~=ec:GetControler() then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	if g:IsContains(e:GetHandler()) then
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
--[[function c999999977.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c999999977.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c999999977.aclimit(e,re,tp)
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end--]]
--[[function c999999977.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and tp==Duel.GetTurnPlayer()
end--]]
function c999999977.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c999999977.negfilter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c999999977.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999977.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c999999977.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c999999977.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g1:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g1:GetNext()
	end
   --[[ local  g2=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local bc=g2:GetFirst()
	while bc do
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetValue(500)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
	    e2:SetCode(EFFECT_UPDATE_DEFENCE) 
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	    e3:SetType(EFFECT_TYPE_SINGLE)
	    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e3:SetRange(LOCATION_MZONE)
	    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	    e3:SetCountLimit(1)
	    e3:SetValue(c999999977.valcon)
		bc:RegisterEffect(e3)
		bc=g2:GetNext()
end--]]
end
--[[function c999999977.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c999999977.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	if bt:IsSetCard(0x999) then
	return r~=REASON_REPLACE and c~=bt and bt:IsFaceup() and bt:GetControler()==c:GetControler()
end
end
function c999999977.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeAttackTarget(e:GetHandler())
end
function c999999977.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	if tc:IsSetCard(0x999) then
	e:SetLabelObject(tc)
	return tc:IsOnField()
end
end
function c999999977.ctfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c999999977.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsOnField() and c999999977.ctfilter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c999999977.ctfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
end
function c999999977.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(c))
	end
end--]]
