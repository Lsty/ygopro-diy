--女仆少女  辛希雅
function c3030324.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20663556,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3030324)
	e1:SetTarget(c3030324.target)
	e1:SetOperation(c3030324.operation)
	c:RegisterEffect(e1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65277087,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c3030324.cost)
	e1:SetCondition(c3030324.condition)
	e1:SetTarget(c3030324.tg)
	e1:SetOperation(c3030324.op)
	c:RegisterEffect(e1)
end
function c3030324.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==1 then 
		Duel.DiscardDeck(tp,1,REASON_COST)
		e:SetLabel(1)
	else
		local ac=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,2))
		if ct==2 then ac=Duel.AnnounceNumber(tp,1,2)
		else ac=Duel.AnnounceNumber(tp,1,2,3) end
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c3030324.filter(c,e,tp)
	return c:IsSetCard(0xaabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3030324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c3030324.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3030324.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c3030324.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3030324.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
	e:SetLabel(g:GetCount())
	local ct=e:GetLabel()
	local sg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Draw(1-tp,ct,REASON_EFFECT)
	end
end
function c3030324.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c3030324.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) end
end
function c3030324.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetDecktopGroup(1-tp,1)
	local tc=sg:GetFirst()
	Duel.Draw(1-tp,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
end