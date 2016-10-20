--May-Raias Defender
function c87002905.initial_effect(c)
	c:EnableReviveLimit()
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002905,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c87002905.spcon1)
	e1:SetTarget(c87002905.sptg)
	e1:SetOperation(c87002905.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87002905,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c87002905.spcon2)
	e2:SetTarget(c87002905.sptg)
	e2:SetOperation(c87002905.spop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87002905,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c87002905.damcon)
	e3:SetTarget(c87002905.damtg)
	e3:SetOperation(c87002905.damop)
	c:RegisterEffect(e3)
end
function c87002905.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c87002905.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0xe291ca)
end
function c87002905.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,true,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c87002905.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,200,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
function c87002905.damcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c87002905.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c87002905.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
