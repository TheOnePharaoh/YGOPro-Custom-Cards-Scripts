--Mechquipped Caster
function c19007847.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19007847,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c19007847.sptg)
	e1:SetOperation(c19007847.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(c19007847.spcon)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19007847,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c19007847.drtg)
	e3:SetOperation(c19007847.drop)
	c:RegisterEffect(e3)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHANGE_POS)
	e5:SetCountLimit(1,19007847)
	e5:SetCondition(c19007847.poscon)
	e5:SetTarget(c19007847.damtg)
	e5:SetOperation(c19007847.damop)
	c:RegisterEffect(e5)
end
function c19007847.spcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and eg:IsContains(e:GetHandler())
end
function c19007847.spfil(c,e,tp)
  return (c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790)) and not c:IsCode(19007847) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007847.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c19007847.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c19007847.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
  if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19007847.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
  end
end
function c19007847.drfilter(c)
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007847.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c19007847.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c19007847.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c19007847.drfilter,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c19007847.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007847.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c19007847.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end