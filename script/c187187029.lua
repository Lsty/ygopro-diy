--使徒少女－要塞
function c187187029.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86585274,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c187187029.spcost)
	e2:SetTarget(c187187029.sptg)
	e2:SetOperation(c187187029.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40133511,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c187187029.cost)
	e3:SetOperation(c187187029.operation)
	c:RegisterEffect(e3)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64332231,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,187187029)
	e6:SetTarget(c187187029.destg)
	e6:SetOperation(c187187029.desop)
	c:RegisterEffect(e6)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,187187)
	e2:SetCost(c187187029.eqcost)
	e2:SetTarget(c187187029.eqtg)
	e2:SetOperation(c187187029.eqop)
	c:RegisterEffect(e2)
end
function c187187029.eqcfilter(c)
	return c:IsSetCard(0xabb) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c187187029.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187029.eqcfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c187187029.eqcfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c187187029.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c187187029.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c187187029.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c187187029.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c187187029.eqlimit)
	c:RegisterEffect(e1)
end
function c187187029.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xabb)
end
function c187187029.cffilter(c)
	return c:IsSetCard(0x6abb)  and not c:IsPublic()
end
function c187187029.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187029.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c187187029.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c187187029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,241,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c187187029.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,241,tp,tp,false,false,POS_FACEUP)
	end
end
function c187187029.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb)  and not c:IsPublic()
end
function c187187029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187029.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c187187029.cfilter,tp,LOCATION_HAND,0,1,60,nil)
	Duel.ConfirmCards(1-tp,cg)
	e:SetLabel(cg:GetCount())
	Duel.ShuffleHand(tp)
end
function c187187029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(count*800)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c187187029.filter1(c,atk)
	return c:IsFaceup() and c:GetBaseAttack()<atk and c:IsAbleToGrave()
end
function c187187029.dfilter(c,atk)
	return c:IsFaceup()  and c:IsDestructable() and c:IsDefenceBelow(atk)
end
function c187187029.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c187187029.dfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetAttack()) end
	local sg=Duel.GetMatchingGroup(c187187029.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c187187029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if tc:IsFaceup()  then
		local sg1=Duel.GetMatchingGroup(c187187029.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		local sg2=Duel.Destroy(sg1,REASON_EFFECT)
end
end