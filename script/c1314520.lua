--夜夜 天险
function c1314520.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314520,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,1314520)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1314520.totg)
	e1:SetOperation(c1314520.toop)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1314520,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c1314520.potg)
	e2:SetOperation(c1314520.poop)
	c:RegisterEffect(e2)
end 
function c1314520.tgfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:GetLevel()>0 and Duel.IsExistingMatchingCard(c1314520.matfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c1314520.matfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9fd) and c:GetLevel()==lv
end
function c1314520.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1314520.tgfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c1314520.toop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1314520.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local tg=g:GetFirst()
	local lv=tg:GetLevel()
	local mg=Duel.GetMatchingGroup(c1314520.matfilter,tp,LOCATION_DECK,0,nil,lv,e,tp)
	if mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=Duel.SelectMatchingCard(tp,c1314520.matfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
		Duel.Remove(fg,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1314520.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1314520.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9fd)
end
function c1314520.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c1314520.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
	   if c:IsAttackPos() then Duel.ChangePosition(c,0x4)
	   else  Duel.ChangePosition(c,0x1)end
	end
end
