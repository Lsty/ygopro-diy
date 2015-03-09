--梦日记-梦境
function c75500002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75500002.condtion)
	e2:SetTarget(c75500002.target)
	e2:SetOperation(c75500002.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75500002.spcon)
	e3:SetOperation(c75500002.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c75500002.effcon)
	e4:SetTarget(c75500002.efftg)
	e4:SetOperation(c75500002.effop)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
end
function c75500002.cfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c75500002.condtion(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75500002.cfilter,1,nil,1-tp)
end
function c75500002.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75500002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c75500002.cfilter,nil,1-tp)
	if chk==0 then return ct==1 or (ct==2 and Duel.IsPlayerCanDraw(tp,1)) or (ct>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c75500002.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) end
	if ct==1 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	elseif ct==2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c75500002.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	e:SetLabel(ct)
end
function c75500002.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	if ct==1 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	elseif ct==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c75500002.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c75500002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75500002.spfilter,1,nil,1-tp)
end
function c75500002.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local g=eg:GetCount()
	e:GetLabelObject():SetLabel(ct+g)
end
function c75500002.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0 and Duel.GetTurnPlayer()==tp
end
function c75500002.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,e:GetLabel())
end
function c75500002.effop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.DiscardDeck(1-tp,e:GetLabel(),REASON_EFFECT)
	e:SetLabel(0)
end