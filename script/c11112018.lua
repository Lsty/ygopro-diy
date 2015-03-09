--怪物猎人 雪狮子
function c11112018.initial_effect(c)
    --disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112018,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11112018)
	e1:SetTarget(c11112018.distg)
	e1:SetOperation(c11112018.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--disable2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11112018,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11112018)
	e3:SetCondition(c11112018.negcon)
	e3:SetTarget(c11112018.negtg)
	e3:SetOperation(c11112018.negop)
	c:RegisterEffect(e3)
end	
function c11112018.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
	    and Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetChainLimit(c11112018.limit(g:GetFirst()))
end
function c11112018.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c11112018.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER)
end
function c11112018.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c11112018.cfilter,nil)
	if ct==0 then
	    if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_CANNOT_TRIGGER)
		    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		    tc:RegisterEffect(e1)
	    end
	else
	    if tc:IsRelateToEffect(e) then
		    Duel.Destroy(tc,REASON_EFFECT)
		end	
	end
end    
function c11112018.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c11112018.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11112018.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112018.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c11112018.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11112018.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end