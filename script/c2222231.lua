--表 清月
function c2222231.initial_effect(c)
       local e1=Effect.CreateEffect(c)
       e1:SetDescription(aux.Stringid(2222231,0))
       e1:SetType(EFFECT_TYPE_IGNITION)
       e1:SetRange(LOCATION_MZONE)
       e1:SetCategory(CATEGORY_RELEASE+CATEGORY_TOKEN)
       e1:SetCost(c2222231.cost)
       e1:SetTarget(c2222231.thtg)
       e1:SetOperation(c2222231.thop)
       c:RegisterEffect(e1) 
       local e2=Effect.CreateEffect(c)
	 e2:SetDescription(aux.Stringid(2222231,1))
	 e2:SetCategory(CATEGORY_TOHAND)
	 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	 e2:SetRange(LOCATION_GRAVE)
	 e2:SetCode(EVENT_SPSUMMON_SUCCESS)
       e2:SetProperty(EFFECT_FLAG_DELAY)
	 e2:SetCondition(c2222231.spcon)
       e2:SetCost(c2222231.sccost)
	 e2:SetTarget(c2222231.sptg)
	 e2:SetOperation(c2222231.spop)
	 c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c2222231.synlimit)
	c:RegisterEffect(e3)
end  
function c2222231.costfilter(c)
        return  c:IsType(TYPE_TRAP) and c:IsSetCard(0x234) and c:IsDiscardable()
end
function c2222231.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222231.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c2222231.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c2222231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,2222233,0x4011,0x4011,800,800,2,RACE_FAIRY,ATTRIBUTE_LIGHT) end      
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c2222231.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,2222233,0x4011,0x4011,800,800,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		local token1=Duel.CreateToken(tp,2222233)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		end
end
function c2222231.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsControler(tp) and tc:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c2222231.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c2222231.thfilter(c)
	return c:GetType()==0x4 and c:IsAbleToHand()
end
function c2222231.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c2222231.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2222231.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c2222231.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c2222231.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c2222231.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x203)
end

