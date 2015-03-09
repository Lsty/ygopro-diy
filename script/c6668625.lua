--另一次元 比那名居天子
function c6668625.initial_effect(c)
	c:SetUniqueOnField(1,0,6668625)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c6668625.sccon)
	e2:SetValue(7)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c6668625.sccon1)
	e4:SetValue(2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,6668625)
	e6:SetCost(c6668625.descost)
	e6:SetTarget(c6668625.destg)
	e6:SetOperation(c6668625.desop)
	c:RegisterEffect(e6)
	--ritual level
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_RITUAL_LEVEL)
	e7:SetValue(c6668625.rlevel)
	c:RegisterEffect(e7)
	--reborn
	local e99=Effect.CreateEffect(c)
	e99:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e99:SetCode(EVENT_TO_GRAVE)
	e99:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e99:SetCountLimit(1,6658625)
	e99:SetCondition(c6668625.descon1)
	e99:SetTarget(c6668625.destg1)
	e99:SetOperation(c6668625.desop1)
	c:RegisterEffect(e99)
end
function c6668625.sccon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsCode(6668614)
end
function c6668625.sccon1(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsCode(6668620)
end
function c6668625.cfilter(c,tp)
	return c:IsSetCard(0x740) and c:IsAbleToGraveAsCost()
end
function c6668625.cfilter1(c,tp)
	return c:IsSetCard(0x741) and c:IsAbleToGraveAsCost()
end
function c6668625.cfilter2(c,tp)
	return c:IsSetCard(0x742) and c:IsAbleToGraveAsCost()
end
function c6668625.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ)
end
function c6668625.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6668625.cfilter,tp,LOCATION_DECK,0,1,nil,tp) 
	and Duel.IsExistingMatchingCard(c6668625.cfilter1,tp,LOCATION_DECK,0,1,nil,tp)
    and Duel.IsExistingMatchingCard(c6668625.cfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c6668625.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c6668625.cfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local g3=Duel.SelectMatchingCard(tp,c6668625.cfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST)
	Duel.SendtoGrave(g3,REASON_COST)
end
function c6668625.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6668625.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c6668625.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6668625.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c6668625.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x743) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c6668625.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:GetHandler():IsSetCard(0x740) 
end
function c6668625.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6668625.desop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end