--Diminutive Sprite of the Glade
function c77777876.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCountLimit(1,77777876)
	e1:SetTarget(c77777876.thtg)
	e1:SetOperation(c77777876.thop)
	c:RegisterEffect(e1)
  --attack limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetOperation(c77777876.flipop)
	c:RegisterEffect(e5)
  --pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777876,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c77777876.spcon)
	e3:SetTarget(c77777876.sptg)
	e3:SetOperation(c77777876.spop)
	c:RegisterEffect(e3)
end

function c77777876.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77777876,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77777876.thfilter(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777876.thfilter2(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77777876.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777876.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c77777876.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777876.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777876.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  local g2=Duel.SelectMatchingCard(tp,c77777876.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  g:Merge(g2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777876.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and (Duel.GetAttackTarget()==nil or (Duel.GetAttackTarget():IsSetCard(0x40c) and Duel.GetAttackTarget():IsFaceup()))
end
function c77777876.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777876.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.ConfirmCards(1-tp,c)
      Duel.NegateAttack()
    end
end
