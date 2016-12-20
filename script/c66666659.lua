--Taika, Lady of Combustion
function c66666659.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x29b))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--PS limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66666659.splimit)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(66666659,0))
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,66666659)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e4:SetCost(c66666659.cost)
	e4:SetTarget(c66666659.target)
	e4:SetOperation(c66666659.operation)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66666659,1))
	e5:SetCountLimit(1)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
--	e5:SetCondition(aux.bdogcon)
	e5:SetTarget(c66666659.sptg)
	e5:SetOperation(c66666659.spop)
	c:RegisterEffect(e5)
	
end

function c66666659.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end


function c66666659.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c66666659.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.Destroy(e:GetHandler(),REASON_COST)~=0 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c66666659.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c66666659.filter(c,e,tp)
	return c:IsSetCard(0x29b) and c:IsLevelBelow(8) and not c:IsCode(66666659)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66666659.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66666659.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66666659.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66666659.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
