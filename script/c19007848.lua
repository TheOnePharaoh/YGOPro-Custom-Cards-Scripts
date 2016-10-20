--Mechquipped Dynos
function c19007848.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19007848,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,19007848)
	e1:SetCondition(c19007848.spcon)
	e1:SetTarget(c19007848.sptg)
	e1:SetOperation(c19007848.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19007848,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c19007848.sccon)
	e2:SetTarget(c19007848.sctg)
	e2:SetOperation(c19007848.scop)
	c:RegisterEffect(e2)
	--shuffle&draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCountLimit(1)
	e3:SetCondition(c19007848.poscon)
	e3:SetTarget(c19007848.drtarg)
	e3:SetOperation(c19007848.drop)
	c:RegisterEffect(e3)
end
function c19007848.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c19007848.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19007848.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19007848.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19007848.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLocation(LOCATION_EXTRA)
end
function c19007848.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c19007848.scfilter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c19007848.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19007848.scfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c19007848.scfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c19007848.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19007848.scfilter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c19007848.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007848.drafilter(c)
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsLocation(LOCATION_HAND) and c:IsAbleToDeck()
end
function c19007848.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		and Duel.IsExistingMatchingCard(c19007848.drafilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c19007848.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19007848.drafilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if sg:IsExists(Card.IsLocation,3,nil,LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end